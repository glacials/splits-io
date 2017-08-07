require "administrate/base_dashboard"

class PatreonUserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    id: Field::String.with_options(searchable: false),
    access_token: Field::String,
    refresh_token: Field::String,
    full_name: Field::String,
    patreon_id: Field::String,
    pledge_cents: Field::Number,
    pledge_created_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :id,
    :access_token,
    :refresh_token,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :id,
    :access_token,
    :refresh_token,
    :full_name,
    :patreon_id,
    :pledge_cents,
    :pledge_created_at,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :access_token,
    :refresh_token,
    :full_name,
    :patreon_id,
    :pledge_cents,
    :pledge_created_at,
  ].freeze

  # Overwrite this method to customize how patreon users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(patreon_user)
    "Patreon - #{patreon_user.full_name}"
  end
end
