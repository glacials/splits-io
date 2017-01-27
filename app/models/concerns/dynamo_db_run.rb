require 'active_support/concern'

module DynamoDBRun
  extend ActiveSupport::Concern

  included do
    def dynamodb_info
      key = {id: id36}
      attrs = 'id, timer, attempts, srdc_id, duration_in_seconds, sum_of_best'

      options = {
        key: key,
        projection_expression: attrs
      }

      resp = $dynamodb_runs.get_item(options)
      info = resp.item

      if info.present?
        info['attempts'] = info['attempts'].to_i
      end

      return info
    end

    def dynamodb_segments
      attrs = 'segment_number, id, title, duration_seconds, start_seconds, end_seconds, is_skipped, is_reduced, is_gold, gold_duration_seconds'
      query = {
        key_condition_expression: 'run_id = :run_id',
        expression_attribute_values: {
          ':run_id' => id36
        },
        projection_expression: attrs
      }

      resp = $dynamodb_segments.query(query)

      if resp.items.length == 0
        parse_into_dynamodb
        resp = $dynamodb_segments.query(query)
      end

      marshalled_segments = []

      resp.items.each do |segment|
        s = Split.new
        s.id = segment['id']
        s.name = segment['title']
        s.duration = segment['duration_seconds'].to_f
        s.start_time = segment['start_seconds'].to_f
        s.finish_time = segment['end_seconds'].to_f
        s.best = segment['gold_duration_seconds'].to_f
        s.gold = segment['is_gold']
        s.skipped = segment['is_skipped']
        s.reduced = segment['is_reduced']

        marshalled_segments << s
      end

      return marshalled_segments
    end

    def dynamodb_history
      attrs = 'run_id, attempt_number, duration_seconds'

      resp = $dynamodb_run_histories.query(
        key_condition_expression: 'run_id = :run_id',
        expression_attribute_values: {
          ':run_id' => id36
        },
        projection_expression: attrs
      )

      attempts = resp.items

      attempts.each do |attempt|
        attempt['attempt_number'] = attempt['attempt_number'].to_i
        attempt['duration_seconds'] = attempt['duration_seconds'].to_f
      end

      return attempts
    end

    def parse_into_dynamodb
      timer_used = nil
      parse_result = nil

      if file.nil?
        return false
      end

      Run.programs.each do |timer|
        parse_result = timer::Parser.new.parse(file, fast: false)

        if parse_result.present?
          timer_used = timer.to_sym
          break
        end
      end

      return false if timer_used.nil?

      if game.nil? || category.nil?
        populate_category(parse_result[:game], parse_result[:category])
      end

      segments = parse_result[:splits]

      segments.each do |segment|
        segment.id = SecureRandom.uuid
      end

      write_run_histories_to_dynamodb(parse_result[:history])
      write_segments_to_dynamodb(segments)
      write_segment_histories_to_dynamodb(segments)

      run = {
        'id' => id36,
        'timer' => timer_used.to_s,
        'attempts' => parse_result[:attempts],
        'srdc_id' => srdc_id || parse_result[:srdc_id].presence,
        'duration_in_seconds' => parse_result[:splits].map { |split| split.duration }.sum.to_f,
        'sum_of_best' => parse_result[:splits].map.all? do |split|
        split.best.present?
      end && parse_result[:splits].map do |split|
        split.best
      end.sum.to_f
      }

      $dynamodb_runs.put_item(item: run)

      assign_attributes(
        srdc_id: run['srdc_id'],
        time: run['duration_in_seconds'],
        sum_of_best: run['sum_of_best']
      )
      save
    end

    def write_run_histories_to_dynamodb(histories)
      marshalled_histories = histories.map.with_index do |history, i|
        marshal_history_into_dynamodb_format(history, i)
      end

      # DynamoDB supports at most 25 parallel writes
      marshalled_histories.each_slice(25) do |history_chunk|
        $dynamodb_client.batch_write_item(
          request_items: {'run_histories' => history_chunk}
        )
      end
    end

    def write_segments_to_dynamodb(segments)
      marshalled_segments = segments.map.with_index do |segment, i|
        marshal_segment_into_dynamodb_format(segment, i)
      end

      # DynamoDB supports at most 25 parallel writes
      marshalled_segments.each_slice(25) do |segment_chunk|
        $dynamodb_client.batch_write_item(
          request_items: {'segments' => segment_chunk}
        )
      end
    end

    def write_segment_histories_to_dynamodb(segments)
      marshalled_segment_histories = segments.map.with_index do |segment, i|
        marshal_segment_histories_into_dynamodb_format(segment, i)
      end

      marshalled_segment_histories.flatten!

      # DynamoDB supports at most 25 parallel writes
      marshalled_segment_histories.each_slice(25) do |segment_history_chunk|
        $dynamodb_client.batch_write_item(
          request_items: {'segment_histories' => segment_history_chunk}
        )
      end
    end

    def marshal_segment_into_dynamodb_format(segment, order)
      {
        put_request: {
          item: {
            'run_id' => id36,
            'segment_number' => order,
            'id' => segment.id,
            'title' => segment.name.presence,
            'duration_seconds' => segment.duration,
            'start_seconds' => segment.start_time,
            'end_seconds' => segment.finish_time,
            'skipped?' => segment.skipped?,
            'reduced?' => segment.reduced?,
            'gold?' => segment.gold?,
            'gold_duration_seconds' => segment.best
          }
        }
      }
    end

    def marshal_history_into_dynamodb_format(history, order)
      {
        put_request: {
          item: {
            'run_id' => id36,
            'attempt_number' => order,
            'duration_seconds' => history
          }
        }
      }
    end

    def marshal_segment_histories_into_dynamodb_format(segment, order)
      if segment.indexed_history.nil?
        return []
      end

      histories = []
      segment.indexed_history.each do |hist|
        attempt_number = hist[0].to_i
        attempt_duration = hist[1]
        h = {
          put_request: {
            item: {
              'segment_id' => segment.id,
              'attempt_number' => attempt_number,
              'run_id' => id36,
              'duration_seconds' => attempt_duration
            }
          }
        }
        histories << h
      end

      return histories
    end
  end
end
