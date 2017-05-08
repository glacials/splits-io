class SegmentHistory < ApplicationRecord
  belongs_to :segment, dependent: :destroy
  has_one :run, through: :segment
end
