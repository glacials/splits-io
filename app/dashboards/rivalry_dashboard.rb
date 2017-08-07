require "administrate/base_dashboard"

class RivalryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    category: Field::BelongsTo,
    from_user: Field::BelongsTo.with_options(class_name: "User"),
    to_user: Field::BelongsTo.with_options(class_name: "User"),
    game: Field::HasOne,
    id: Field::Number,
    from_user_id: Field::Number,
    to_user_id: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :category,
    :from_user,
    :to_user,
    :game,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :category,
    :from_user,
    :to_user,
    :game,
    :id,
    :from_user_id,
    :to_user_id,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :category,
    :from_user,
    :to_user,
    :game,
    :from_user_id,
    :to_user_id,
  ].freeze

  # Overwrite this method to customize how rivalries are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(rivalry)
    "#{rivalry.to_user} vs. #{rivalry.from_user}"
  end
end
