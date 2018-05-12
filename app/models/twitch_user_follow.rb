class TwitchUserFollow < ApplicationRecord
  validates_uniqueness_of :to_user_id, scope: :from_user_id

  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user, class_name: 'User'
end
