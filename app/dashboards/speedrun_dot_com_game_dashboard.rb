require 'administrate/base_dashboard'

class SpeedrunDotComGameDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id:             Field::String.with_options(searchable: false),
    game:           Field::BelongsTo,
    srdc_id:        Field::String,
    name:           Field::String,
    shortname:      Field::String,
    url:            Field::String,
    favicon_url:    Field::String,
    cover_url:      Field::String,
    default_timing: Field::Select.with_options(collection: ['real', 'game']),
    show_ms:        Field::Boolean,
    created_at:     Field::DateTime,
    updated_at:     Field::DateTime,
    twitch_name:    Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    game
    srdc_id
    shortname
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    game
    srdc_id
    name
    shortname
    url
    favicon_url
    cover_url
    default_timing
    show_ms
    created_at
    updated_at
    twitch_name
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    srdc_id
    name
    shortname
    url
    favicon_url
    cover_url
    default_timing
    show_ms
    twitch_name
  ].freeze

  # Overwrite this method to customize how speedrun dot com games are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(speedrun_dot_com_game)
    "#{speedrun_dot_com_game.game}'s speedrun.com link"
  end
end
