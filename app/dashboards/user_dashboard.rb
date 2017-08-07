require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    runs: Field::HasMany,
    categories: Field::HasMany,
    games: Field::HasMany,
    rivalries: Field::HasMany,
    incoming_rivalries: Field::HasMany.with_options(class_name: "Rivalry"),
    id: Field::Number,
    email: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    twitch_token: Field::String,
    twitch_id: Field::Number,
    name: Field::String,
    avatar: Field::String,
    permagold: Field::Boolean,
    twitch_display_name: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :runs,
    :categories,
    :games,
    :rivalries,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :runs,
    :categories,
    :games,
    :rivalries,
    :incoming_rivalries,
    :id,
    :email,
    :created_at,
    :updated_at,
    :twitch_token,
    :twitch_id,
    :name,
    :avatar,
    :permagold,
    :twitch_display_name,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :runs,
    :categories,
    :games,
    :rivalries,
    :incoming_rivalries,
    :email,
    :twitch_token,
    :twitch_id,
    :name,
    :avatar,
    :permagold,
    :twitch_display_name,
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    user
  end
end
