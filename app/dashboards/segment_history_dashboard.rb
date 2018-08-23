require 'administrate/base_dashboard'

class SegmentHistoryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::String.with_options(searchable: false),
    run: Field::HasOne,
    segment: Field::BelongsTo,
    attempt_number: Field::Number.with_options(prefix: '#'),
    realtime_duration_ms: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    gametime_duration_ms: Field::Number
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    run
    segment
    attempt_number
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    run
    segment
    attempt_number
    realtime_duration_ms
    gametime_duration_ms
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    segment
    run
    attempt_number
    realtime_duration_ms
    gametime_duration_ms
  ].freeze

  # Overwrite this method to customize how segment histories are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(segment_history)
  #   "SegmentHistory ##{segment_history.id}"
  # end
end
