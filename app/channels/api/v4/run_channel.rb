class Api::V4::RunChannel < Api::V4::ApplicationChannel
  def subscribed
    @run = Run.find36(params[:run_id])
    if @run.nil?
      transmit_user("run_not_found", "No run found with id: #{params[:run_id]}")
      reject
      return
    end

    ParseRunJob.perform_later(@run) unless @run.parsed?

    stream_for(@run)
    transmit(Api::V4::WebsocketMessage.new(
      "run_state",
      message: "Run state",
      run: Api::V4::RunBlueprint.render_as_hash(@run),
    ).to_h)
  end

  def unsubscribed
    stop_all_streams
  end
end
