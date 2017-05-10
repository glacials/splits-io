class Segment < ApplicationRecord
  belongs_to :run
  has_many :histories, class_name: 'SegmentHistory', dependent: :destroy

  default_scope { order(segment_number: :asc) }
end
