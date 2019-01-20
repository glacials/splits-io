require "administrate/base_dashboard"

class TwitchUserFollowDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id:           Field::Number,
    from_user_id: Field::Number,
    from_user:    Field::BelongsTo.with_options(class_name: 'User'),
    to_user_id:   Field::Number,
    to_user:      Field::BelongsTo.with_options(class_name: 'User'),
    created_at:   Field::DateTime,
    updated_at:   Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    from_user
    to_user
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    from_user,
    to_user
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    from_user_id
    to_user_id
  ].freeze

  # Overwrite this method to customize how twitch user follows are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(twitch_user_follow)
    "#{twitch_user_follow.from_user}'s follow of #{twitch_user_follow.to_user}"
  end
end
