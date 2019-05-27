class Api::V1::WebsocketMessage
  attr_reader :type, :data

  TYPES = %w[
    user_absent_error
    oauth_expired_error
    oauth_blank_error
    oauth_scope_error
    user_mismatch_error
    oauth_updated

    global_state
    race_creation_success
    race_creation_error
    race_created
    race_started
    race_updated
    race_finished

    race_not_found
    race_invalid_join_token
    race_state
    race_read_only

    in_race_error

    race_started_error
    race_join_error
    race_join_success

    race_leave_error
    race_leave_success

    race_ready_error
    race_ready_success

    race_unready_error
    race_unready_success

    race_not_started_error
    race_finished_error
    race_done_error
    race_forfeit_error
    race_forfeit_success

    race_done_error
    race_done_success

    race_rejoin_error
    race_rejoin_success

    race_start_scheduled
    race_ended

    race_entrants_updated

    message_creation_success
    new_message
    message_creation_error

    new_attachment

    fatal_error
  ].freeze

  def initialize(type, **data)
    raise "Invalid type #{type}" unless TYPES.include?(type)
    raise '"message" required as keyword argument' if data[:message].blank?

    @type = type
    @data = data
  end
end
