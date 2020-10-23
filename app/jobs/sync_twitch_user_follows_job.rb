class SyncTwitchUserFollowsJob < ApplicationJob
  # Adding or deleting a job? Reflect the change in the QUEUES environment variable in docker-compose.yml and
  # docker-compose-production.yml.
  queue_as :sync_user_follows

  def perform(twitch_user)
    ActiveRecord::Base.transaction do
      followed_twitch_users_according_to_twitch = TwitchUser.where(twitch_id: twitch_user.followed_twitch_ids.to_a)

      newly_unfollowed_twitch_users = twitch_user.follows - followed_twitch_users_according_to_twitch
      newly_followed_twitch_users   = followed_twitch_users_according_to_twitch - twitch_user.follows

      TwitchUserFollow.where(from_twitch_user: twitch_user, to_twitch_user: newly_unfollowed_twitch_users).destroy_all

      TwitchUserFollow.import!(newly_followed_twitch_users.map do |to_twitch_user|
        TwitchUserFollow.new(from_twitch_user: twitch_user, to_twitch_user: to_twitch_user)
      end)
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid => e
    twitch_user.update(follows_synced_at: Time.new(1970))
    raise e
  end
end
