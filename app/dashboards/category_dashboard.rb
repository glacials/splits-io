require 'administrate/base_dashboard'

class CategoryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id:         Field::Number,
    game:       Field::BelongsTo,
    game_id:    Field::Number,
    name:       Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    shortname:  Field::String,

    runs:      Field::HasMany,
    rivalries: Field::HasMany,
    races:     Field::HasMany,

    speedrun_dot_com_category: Field::HasOne,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    game
    name
    shortname

    runs
    rivalries
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    game
    shortname
    name
    created_at
    updated_at

    speedrun_dot_com_category

    runs
    rivalries
    races
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    game_id
    name
    shortname
  ].freeze

  # Overwrite this method to customize how categories are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(category)
    "#{category.game} #{category}"
  end
end
