require "administrate/base_dashboard"

class GoogleUserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id:                      Field::String.with_options(searchable: false),
    user_id:                 Field::Number,
    user:                    Field::BelongsTo,
    google_id:               Field::String,
    access_token:            Field::Password,
    access_token_expires_at: Field::DateTime,
    name:                    Field::String,
    email:                   Field::String,
    first_name:              Field::String,
    last_name:               Field::String,
    avatar:                  Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    user
    first_name
    last_name
    email
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    user
    id
    google_id
    access_token
    access_token_expires_at
    name
    email
    first_name
    last_name
    avatar
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    user_id
  ].freeze

  # Overwrite this method to customize how google users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(google_user)
    "#{google_user.user}'s Google user"
  end
end
