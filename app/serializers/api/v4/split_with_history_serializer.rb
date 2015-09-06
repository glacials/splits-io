class Api::V4::SplitWithHistorySerializer < Api::V4::ApplicationSerializer
  has_one :name, :duration, :best, :finish_time, :gold, :skipped
  attributes :history

  def history
    object.history || []
  end
end
