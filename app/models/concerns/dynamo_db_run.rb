require 'active_support/concern'

module DynamoDBRun
  extend ActiveSupport::Concern

  included do
    def dynamodb_history
      attrs = 'attempt_number, duration_seconds'

      resp = $dynamodb_run_histories.query(
        key_condition_expression: 'run_id = :run_id',
        expression_attribute_values: {
          ':run_id' => id36
        },
        projection_expression: attrs
      )

      history = resp.items
      if history.length == 0
        return []
      end

      history_map = {}
      history.each do |attempt|
        attempt_number = attempt['attempt_number'].to_i
        duration_seconds = attempt['duration_seconds'].try(:to_f)

        history_map[attempt_number] = {
          attempt_number: attempt_number,
          duration_seconds: duration_seconds
        }
      end

      # full_history fills in all attempts, even uncompleted ones
      full_history = []
      (1..history.last['attempt_number']).each do |attempt_number|
        if history_map[attempt_number].nil?
          full_history << {
            attempt_number: attempt_number,
            duration_seconds: nil
          }
          next
        end

        full_history << history_map[attempt_number]
      end

      return full_history
    end

    def write_run_histories_to_dynamodb(histories)
      marshalled_histories = histories.map do |attempt_number, duration_seconds|
        marshal_history_into_dynamodb_format(attempt_number, duration_seconds)
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
          request_items: {'segments_v1' => segment_chunk}
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
            'is_skipped' => segment.skipped?,
            'is_reduced' => segment.reduced?,
            'is_gold' => segment.gold?,
            'gold_duration_seconds' => segment.best
          }
        }
      }
    end

    def marshal_history_into_dynamodb_format(attempt_number, duration_seconds)
      {
        put_request: {
          item: {
            'run_id' => id36,
            'attempt_number' => attempt_number,
            'duration_seconds' => duration_seconds
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
