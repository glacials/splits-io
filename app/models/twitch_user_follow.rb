class TwitchUserFollow < ApplicationRecord
  validates :to_twitch_user_id, uniqueness: {scope: :from_twitch_user_id}

  belongs_to :from_twitch_user, class_name: 'TwitchUser'
  belongs_to :to_twitch_user,   class_name: 'TwitchUser'
end
