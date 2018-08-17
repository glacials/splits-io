require 'administrate/base_dashboard'

class GameDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    categories: Field::HasMany,
    runs: Field::HasMany,
    aliases: Field::HasMany.with_options(class_name: 'GameAlias'),
    id: Field::Number,
    name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    shortname: Field::String
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    shortname
    name
    categories
    runs
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    categories
    runs
    aliases
    id
    name
    created_at
    updated_at
    shortname
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    categories
    runs
    aliases
    name
    shortname
  ].freeze

  # Overwrite this method to customize how games are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(game)
    game
  end
end
