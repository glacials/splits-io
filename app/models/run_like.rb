class RunLike < ApplicationRecord
  belongs_to :run
  belongs_to :user

  validates :user_id, uniqueness: {scope: :run_id}
end
