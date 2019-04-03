class DiscoverRunnerJob < ApplicationJob
  queue_as :discover_runner

  def perform(run)
    return if run.srdc_id.nil?

    srdc_runner_id = SpeedrunDotCom::Run.runner_id(run.srdc_id)
    return if srdc_runner_id.nil?

    twitch_login = SpeedrunDotCom::User.twitch_login(srdc_runner_id)
    return if twitch_login.blank?

    run.update(user: User.joins(:twitch).find_by(twitch_users: {name: twitch_login}))
  end
end
