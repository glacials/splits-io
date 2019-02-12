class Runs::ExportsController < Runs::ApplicationController
  before_action :set_run, only: [:timer, :history_csv, :segment_history_csv]
  before_action :first_parse, only: [:download], if: -> { @run.parsed_at.nil? }

  def timer
    # Enable CORS for this endpoint so clients can download files; this should be an API endpoint but I'm not sure how I
    # want the timer-specific views to belong to both an API namespace and a user namespace
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    timer = Run.program(params[:timer])
    if timer.nil?
      redirect_to run_path(@run), alert: 'Unrecognized timer.'
      return
    end

    if timer == Run.program(@run.timer)
      begin
        s3_file = $s3_bucket_internal.object("splits/#{@run.s3_filename}")
        if s3_file.exists?
          redirect_to s3_file.presigned_url(
            :get,
            response_content_disposition: "attachment; filename=\"#{@run.filename}\""
          )
          return
        end
      rescue Aws::S3::Errors::Forbidden
      end
    end

    send_data(
      if timer == Run.program(@run.timer) && params[:blank] != '1'
        @run.file
      else
        render_to_string(timer.to_sym, layout: false)
      end,
      filename: @run.filename(timer: timer).to_s,
      layout: false
    )
  end


  def history_csv
    @run.parse_into_db unless @run.parsed?

    column_names = ['Attempt #', 'Realtime (ms)', 'Gametime (ms)']

    csv = CSV.generate do |doc|
      doc << column_names
      @run.histories.each do |history|
        doc << [history.attempt_number, history.realtime_duration_ms, history.gametime_duration_ms]
      end
    end

    send_data(csv, filename: "#{@run.id36}_history.csv", layout: false)
  end

  def segment_history_csv
    @run.parse_into_db unless @run.parsed?

    if @run.attempts.nil? || @run.attempts.zero?
      redirect_to run_path(@run), alert: 'Segment history is not available for this run.'
      return
    end

    csv = CSV.generate do |doc|
      header = ['Segment name']

      attempts = if @run.segments.empty? || @run.segments.first.histories.empty?
                   0
                 else
                   @run.segments.first.histories.order(attempt_number: :asc).last.attempt_number
                 end

      (1..attempts).each do |attempt_number|
        header << "Attempt ##{attempt_number}'s Duration (ms)"
      end
      doc << header

      @run.segments.order(segment_number: :asc).includes(:histories).each do |segment|
        row = []
        row << segment.name
        next if segment.histories.empty?

        attempt_number = 1
        segment.histories.sort_by(&:attempt_number).each do |h|
          while h.attempt_number > attempt_number
            row << ''
            attempt_number += 1
          end
          row << h.duration_ms(Run::REAL)
          attempt_number += 1
        end
        doc << row
      end
    end

    send_data(csv, filename: "#{@run.id36}_segment_history.csv", layout: false)
  end
end
