class Api::V4::WebsocketMessage
  attr_reader :type, :data

  TYPES = %w[
    connection_error
    fatal_error
    global_state
    race_created
    race_started
    race_updated

    race_not_found
    race_invalid_join_token
    race_state

    race_start_scheduled
    race_ended

    race_entries_updated

    new_message

    new_attachment
    new_card

    run_state
    run_parsed
    run_not_found
    cant_parse_run
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
