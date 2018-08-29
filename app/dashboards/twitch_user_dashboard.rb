require 'administrate/base_dashboard'

class TwitchUserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id:                Field::String.with_options(searchable: false),
    user:              Field::BelongsTo,
    access_token:      Field::Password,
    twitch_id:         Field::String,
    name:              Field::String,
    display_name:      Field::String,
    email:             Field::String,
    avatar:            Field::String,
    follows_synced_at: Field::DateTime,
    created_at:        Field::DateTime,
    updated_at:        Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    user
    display_name
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    user
    id
    twitch_id
    name
    display_name
    email
    avatar
    access_token
    follows_synced_at
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    follows_synced_at
  ].freeze

  # Overwrite this method to customize how twitch users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(twitch_user)
    twitch_user.display_name
  end
end
