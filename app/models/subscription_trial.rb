class SubscriptionTrial < ApplicationRecord
  TRIAL_DURATION = 14.days

  belongs_to :user

  validates :user_id, presence: true, uniqueness: true

  def ended_at
    created_at + TRIAL_DURATION
  end

  def expired?
    Time.now.utc > ended_at
  end

  def has_predictions?
    !expired?
  end

  def has_redirectors?
    !expired?
  end

  def has_advanced_comparisons?
    !expired?
  end

  def has_sum_of_best_leaderboards?
    !expired?
  end

  def has_hiding?
    !expired?
  end

  def has_advanced_video?
    !expired?
  end

  def has_autohighlight?
    !expired?
  end

  def has_advanced_analytics?
    !expired?
  end

  def has_srdc_submit?
    !expired?
  end
end
