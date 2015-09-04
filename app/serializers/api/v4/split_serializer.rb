class Api::V4::SplitSerializer < Api::V4::ApplicationSerializer
  has_one :name, :duration, :best, :finish_time, :gold, :skipped
end
