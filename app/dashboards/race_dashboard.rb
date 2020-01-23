require "administrate/base_dashboard"

class RaceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    game: Field::BelongsTo,
    category: Field::BelongsTo,
    owner: Field::BelongsTo.with_options(class_name: "User"),
    entries: Field::HasMany,
    runners: Field::HasMany.with_options(class_name: "User"),
    chat_messages: Field::HasMany,
    attachments_attachments: Field::HasMany.with_options(class_name: "ActiveStorage::Attachment"),
    attachments_blobs: Field::HasMany.with_options(class_name: "ActiveStorage::Blob"),
    id: Field::String.with_options(searchable: false),
    visibility: Field::String.with_options(searchable: false),
    join_token: Field::String,
    notes: Field::String,
    started_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  user
  game
  category
  owner
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  user
  game
  category
  owner
  entries
  runners
  chat_messages
  attachments_attachments
  attachments_blobs
  id
  visibility
  join_token
  notes
  started_at
  created_at
  updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  user
  game
  category
  owner
  entries
  runners
  chat_messages
  attachments_attachments
  attachments_blobs
  visibility
  join_token
  notes
  started_at
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

  # Overwrite this method to customize how races are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(race)
  #   "Race ##{race.id}"
  # end
end
