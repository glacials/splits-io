require "administrate/base_dashboard"

class SpeedrunDotComCategoryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    category:    Field::BelongsTo,
    id:          Field::String.with_options(searchable: false),
    srdc_id:     Field::String,
    name:        Field::String,
    url:         Field::String,
    misc:        Field::Boolean,
    rules:       Field::String,
    min_players: Field::Number,
    max_players: Field::Number,
    created_at:  Field::DateTime,
    updated_at:  Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    category
    id
    srdc_id
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    category
    id
    srdc_id
    name
    url
    misc
    rules
    min_players
    max_players
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    srdc_id
    name
    url
    misc
    rules
    min_players
    max_players
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how speedrun dot com categories are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(speedrun_dot_com_category)
    "#{speedrun_dot_com_category.category.game} #{speedrun_dot_com_category.category}'s speedrun.com link"
  end
end
