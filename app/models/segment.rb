class Segment < ApplicationRecord
  belongs_to :run, dependent: :destroy
  has_many :histories, class_name: 'SegmentHistory'
end
