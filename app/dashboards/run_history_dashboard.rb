require 'administrate/base_dashboard'

class RunHistoryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::String.with_options(searchable: false),
    run_id: Field::String,
    run: Field::BelongsTo,
    attempt_number: Field::Number.with_options(prefix: '#'),
    realtime_duration_ms: Field::Number.with_options(suffix: 'ms'),
    gametime_duration_ms: Field::Number.with_options(suffix: 'ms'),
    started_at: Field::DateTime,
    ended_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    run
    attempt_number
    realtime_duration_ms
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    run
    attempt_number
    realtime_duration_ms
    gametime_duration_ms
    created_at
    updated_at
    started_at
    ended_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    run_id
    attempt_number
    realtime_duration_ms
    gametime_duration_ms
    started_at
    ended_at
  ].freeze

  # Overwrite this method to customize how run histories are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(run_history)
    "#{run_history.run.user}'s #{run_history.attempt_number.ordinalize} attempt for #{run_history.run}"
  end
end
