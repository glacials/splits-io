require 'administrate/base_dashboard'

class SegmentDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::String.with_options(searchable: false),
    run: Field::BelongsTo,
    name: Field::String,
    segment_number: Field::Number.with_options(prefix: '#'),
    realtime_duration_ms: Field::Number.with_options(suffix: 'ms'),
    realtime_start_ms: Field::Number.with_options(suffix: 'ms'),
    realtime_end_ms: Field::Number.with_options(suffix: 'ms'),
    realtime_shortest_duration_ms: Field::Number.with_options(suffix: 'ms'),
    realtime_gold: Field::Boolean.with_options(suffix: 'ms'),
    realtime_reduced: Field::Boolean,
    realtime_skipped: Field::Boolean,
    gametime_start_ms: Field::Number.with_options(suffix: 'ms'),
    gametime_end_ms: Field::Number.with_options(suffix: 'ms'),
    gametime_duration_ms: Field::Number.with_options(suffix: 'ms'),
    gametime_shortest_duration_ms: Field::Number.with_options(suffix: 'ms'),
    gametime_gold: Field::Boolean.with_options(suffix: 'ms'),
    gametime_reduced: Field::Boolean,
    gametime_skipped: Field::Boolean,
    histories: Field::HasMany.with_options(class_name: 'SegmentHistory', limit: 10),
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    run
    segment_number
    histories
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    run
    name
    segment_number
    realtime_duration_ms
    realtime_start_ms
    realtime_end_ms
    realtime_shortest_duration_ms
    realtime_gold
    realtime_reduced
    realtime_skipped
    gametime_start_ms
    gametime_end_ms
    gametime_duration_ms
    gametime_shortest_duration_ms
    gametime_gold
    gametime_reduced
    gametime_skipped
    histories
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    run
    histories
    segment_number
    realtime_duration_ms
    realtime_start_ms
    realtime_end_ms
    realtime_shortest_duration_ms
    name
    realtime_gold
    realtime_reduced
    realtime_skipped
    gametime_start_ms
    gametime_end_ms
    gametime_duration_ms
    gametime_shortest_duration_ms
    gametime_gold
    gametime_reduced
    gametime_skipped
  ].freeze

  # Overwrite this method to customize how segments are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(segment)
    segment.name
  end
end
