require 'administrate/base_dashboard'

class SpeedRunsLiveGameDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id:              Field::String.with_options(searchable: false),
    game_id:         Field::Number,
    game:            Field::BelongsTo,
    srl_id:          Field::String,
    name:            Field::String,
    shortname:       Field::String,
    popularity:      Field::Number,
    popularity_rank: Field::Number,
    created_at:      Field::DateTime,
    updated_at:      Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    game
    name
    shortname
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    game
    srl_id
    name
    shortname
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    game_id
    srl_id
    name
    shortname
  ].freeze

  def display_resource(srl)
    "#{srl.game}'s SRL link"
  end
end
