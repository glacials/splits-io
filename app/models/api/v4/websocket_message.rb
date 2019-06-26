class Api::V4::WebsocketMessage
  attr_reader :type, :data

  TYPES = %w[
    fatal_error
    global_state
    raceable_created
    raceable_started
    raceable_updated

    raceable_not_found
    raceable_invalid_join_token
    raceable_state

    raceable_start_scheduled
    raceable_ended

    raceable_entries_updated

    new_message

    new_attachment
    new_card
  ].freeze

  HTML_TYPES = TYPES.map { |t| "#{t}:html" }.freeze

  def initialize(type, **data)
    raise "Invalid type #{type}" unless TYPES.include?(type) || HTML_TYPES.include?(type)
    raise '"message" required as keyword argument' if data[:message].blank?

    @type = type
    @data = data
  end

  def to_h
    {
      type: @type,
      data: @data
    }
  end
end
