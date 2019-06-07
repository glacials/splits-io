class Api::V4::WebsocketMessage
  attr_reader :type, :data

  TYPES = %w[
    global_state
    race_created
    race_started
    race_updated
    race_finished

    race_not_found
    race_invalid_join_token
    race_state

    race_start_scheduled
    race_ended

    race_entrants_updated

    new_message

    new_attachment
  ].freeze

  HTML_TYPES = TYPES.map { |t| "#{t}:html" }

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
