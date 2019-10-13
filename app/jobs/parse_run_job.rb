class ParseRunJob < ApplicationJob
  # Adding or deleting a job? Reflect the change in the QUEUES environment variable in docker-compose.yml and
  # docker-compose-production.yml.
  queue_as :parse_run

  def perform(run)
    return if run.nil?

    run.parse_into_db

    raise UnparsedRun::UnparsableRun unless run.parsed?

    Api::V4::RunChannel.broadcast_to(run, Api::V4::WebsocketMessage.new('run_parsed', message: 'Run parsed').to_h)
  rescue UnparsedRun::UnparsableRun, UnparsedRun::RunFileMissing
    Api::V4::RunChannel.broadcast_to(
      run,
      Api::V4::WebsocketMessage.new('cant_parse_run', message: 'Run cannot be parsed').to_h
    )
  end
end
