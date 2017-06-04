class SegmentHistory < ApplicationRecord
  belongs_to :segment
  has_one :run, through: :segment
end
