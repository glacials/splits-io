require "administrate/base_dashboard"

class RunDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    category: Field::BelongsTo,
    game: Field::HasOne,
    segments: Field::HasMany,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    nick: Field::String,
    image_url: Field::String,
    realtime_duration_s: Field::String.with_options(searchable: false),
    program: Field::String,
    claim_token: Field::String,
    realtime_sum_of_best_s: Field::String.with_options(searchable: false),
    archived: Field::Boolean,
    video_url: Field::String,
    srdc_id: Field::String,
    attempts: Field::Number,
    s3_filename: Field::String,
    realtime_duration_ms: Field::Number,
    realtime_sum_of_best_ms: Field::Number,
    parsed_at: Field::DateTime,
    gametime_duration_ms: Field::Number,
    gametime_sum_of_best_ms: Field::Number,
    default_timing: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :category,
    :game,
    :segments,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :category,
    :game,
    :segments,
    :id,
    :created_at,
    :updated_at,
    :nick,
    :image_url,
    :realtime_duration_s,
    :program,
    :claim_token,
    :realtime_sum_of_best_s,
    :archived,
    :video_url,
    :srdc_id,
    :attempts,
    :s3_filename,
    :realtime_duration_ms,
    :realtime_sum_of_best_ms,
    :parsed_at,
    :gametime_duration_ms,
    :gametime_sum_of_best_ms,
    :default_timing,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :category,
    :game,
    :segments,
    :nick,
    :image_url,
    :realtime_duration_s,
    :program,
    :claim_token,
    :realtime_sum_of_best_s,
    :archived,
    :video_url,
    :srdc_id,
    :attempts,
    :s3_filename,
    :realtime_duration_ms,
    :realtime_sum_of_best_ms,
    :parsed_at,
    :gametime_duration_ms,
    :gametime_sum_of_best_ms,
    :default_timing,
  ].freeze

  # Overwrite this method to customize how runs are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(run)
    run
  end
end
