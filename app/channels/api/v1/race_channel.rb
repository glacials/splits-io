class Api::V1::RaceChannel < ApplicationCable::Channel
  def subscribed
    @race = Raceable.race_from_type(params[:race_type]).find_by(id: params[:race_id])
    @permitted = true
    if @race.nil?
      transmit_user('race_not_found', "No race found with id: #{params[:race_id]}")
      reject
      return
    end

    if @race.invite_only_visibility? && !@race.joinable?(user: current_user, token: params[:join_token])
      @permitted = false
      transmit_user('race_read_only', 'Invalid or no join token')
    end

    if @race.secret_visibility? && !@race.joinable?(user: current_user, token: params[:join_token])
      transmit_user('race_invalid_join_token', 'The join token provided is not valid for this race')
      reject
    else
      stream_for(@race)
      return unless params[:state] == '1'

      ws_msg = Api::V1::WebsocketMessage.new(
        'race_state',
        message: 'Race state',
        race:    Api::V4::RaceBlueprint.render_as_hash(@race, view: @race.type, chat: true)
      )

      transmit(Api::V1::WebsocketMessageBlueprint.render_as_hash(ws_msg))
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def join
    return unless @permitted

    update_race_instance

    entrant = @race.entrants.create(user: current_user)
    if entrant.persisted?
      transmit_user('race_join_success', 'Race successfully joined')
      broadcast_race_update('race_entrants_updated', 'A new entrant has join the race')
      GlobalRaceUpdateJob.perform_later('race_entrants_updated', 'A new entrnat has joined', @race)
    else
      transmit_user(entrant.error_status! || 'race_join_error', entrant.errors.full_messages.to_sentence)
    end
  rescue StandardError => e
    Rails.logger.error(e)
    Rollbar.error(e, 'Uncaught error for Api::V1::RaceChannel#join')
    transmit_user('fatal_error', 'A fatal error occurred while processing your message')
  end

  def leave
    return unless @permitted

    update_race_instance

    entrant = Entrant.find_by(raceable: @race, user: current_user)
    return if entrant.nil?

    if entrant.destroy
      transmit_user('race_leave_success', 'Race successfully left')
      broadcast_race_update('race_entrants_updated', 'An entrant has left the race')
      GlobalRaceUpdateJob.perform_later('race_entrants_updated', 'An entrant has left', @race)
    else
      transmit_user(entrant.error_status! || 'race_leave_error', entrant.errors.full_messages.to_sentence)
    end
  rescue StandardError => e
    Rails.logger.error(e)
    Rollbar.error(e, 'Uncaught error for Api::V1::RaceChannel#leave')
    transmit_user('fatal_error', 'A fatal error occurred while processing your message')
  end

  def ready
    return unless @permitted

    update_race_instance

    entrant = Entrant.find_by(raceable: @race, user: current_user)
    return if entrant.nil?

    if entrant.update(readied_at: Time.now.utc)
      transmit_user('race_ready_success', 'Entrant ready successful')
      broadcast_race_update('race_entrants_updated', 'An entrant has readied up')
      maybe_start_race
    else
      transmit_user(entrant.error_status! || 'race_ready_error', entrant.errors.full_messages.to_sentence)
    end
  rescue StandardError => e
    Rails.logger.error(e)
    Rollbar.error(e, 'Uncaught error for Api::V1::RaceChannel#ready')
    transmit_user('fatal_error', 'A fatal error occurred while processing your message')
  end

  def unready
    return unless @permitted

    update_race_instance

    entrant = Entrant.find_by(raceable: @race, user: current_user)
    return if entrant.nil?

    if entrant.update(readied_at: nil)
      transmit_user('race_unready_success', 'Entrant unready successful')
      broadcast_race_update('race_entrants_updated', 'An entrant has unreadied')
    else
      transmit_user(entrant.error_status! || 'race_unready_error', entrant.errors.full_messages.to_sentence)
    end
  rescue StandardError => e
    Rails.logger.error(e)
    Rollbar.error(e, 'Uncaught error for Api::V1::RaceChannel#unready')
    transmit_user('fatal_error', 'A fatal error occurred while processing your message')
  end

  def forfeit(data)
    # Immediately take a timestamp in case there is no server time passed in
    # This is to try and make sure ff's have the most accurate time
    forfeit_time = Time.now.utc
    forfeit_time = Time.at(data['server_time'] / 1000).utc if data['server_time'].present?

    return unless @permitted

    update_race_instance

    entrant = Entrant.find_by(raceable: @race, user: current_user)
    return if entrant.nil?

    if entrant.update(finished_at: nil, forfeited_at: forfeit_time)
      transmit_user('race_forfeit_success', 'Entrant forfeit successful')
      broadcast_race_update('race_entrants_updated', 'An entrant has forfeited')
      maybe_end_race
    else
      transmit_user(entrant.error_status! || 'race_forfeit_error', entrant.errors.full_messages.to_sentence)
    end
  rescue StandardError => e
    Rails.logger.error(e)
    Rollbar.error(e, 'Uncaught error for Api::V1::RaceChannel#forfeit')
    transmit_user('fatal_error', 'A fatal error occurred while processing your message')
  end

  def done(data)
    # Immediately take a timestamp in case there is no server time passed in
    # This is to try and make sure dones have the most accurate time
    done_time = Time.now.utc
    done_time = Time.at(data['server_time'] / 1000).utc if data['server_time'].present?

    return unless @permitted

    update_race_instance

    entrant = Entrant.find_by(raceable: @race, user: current_user)
    return if entrant.nil?

    if entrant.update(finished_at: done_time, forfeited_at: nil)
      transmit_user('race_done_success', 'Entrant done successful')
      broadcast_race_update('race_entrants_updated', 'An entrant has finished')
      maybe_end_race
    else
      transmit_user(entrant.error_status! || 'race_done_error', entrant.errors.full_messages.to_sentence)
    end
  rescue StandardError => e
    Rails.logger.error(e)
    Rollbar.error(e, 'Uncaught error for Api::V1::RaceChannel#done')
    transmit_user('fatal_error', 'A fatal error occurred while processing your message')
  end

  def rejoin
    return unless @permitted

    update_race_instance

    entrant = Entrant.find_by(raceable: @race, user: current_user)
    return if entrant.nil?

    if entrant.update(finished_at: nil, forfeited_at: nil)
      transmit_user('race_rejoin_success', 'Entrant rejoin successful')
      broadcast_race_update('race_entrants_updated', 'An entrant has rejoined the race')
    else
      transmit_user(entrant.error_status! || 'race_rejoin_error', entrant.errors.full_messages.to_sentence)
    end
  rescue StandardError => e
    Rails.logger.error(e)
    Rollbar.error(e, 'Uncaught error for Api::V1::RaceChannel#rejoin')
    transmit_user('fatal_error', 'A fatal error occurred while processing your message')
  end

  def send_message(data)
    return unless @permitted

    update_race_instance
    chat_message = @race.chat_messages.create(
      user: current_user, body: data['body'],
      entrant: @race.entrant_for_user(current_user).present?
    )
    if chat_message.persisted?
      transmit_user('message_creation_success', 'Messages successfully created')
      message = {
        message:      'A new message has been posted',
        chat_message: Api::V4::ChatMessageBlueprint.render_as_hash(chat_message)
      }
      if onsite
        message[:chat_html] = ApplicationController.render(
          partial: 'chat_messages/show',
          locals:  {chat_message: chat_message}
        )
      end

      broadcast_to(
        @race,
        Api::V1::WebsocketMessageBlueprint.render_as_hash(
          Api::V1::WebsocketMessage.new('new_message', message)
        )
      )
    else
      transmit_user('message_creation_error', message.errors.full_messages.to_sentence)
    end
  rescue StandardError => e
    Rails.logger.error(e)
    Rollbar.error(e, 'Uncaught error for Api::V1::RaceChannel#send_message')
    transmit_user('fatal_error', 'A fatal error occurred while processing your message')
  end

  private

  def update_race_instance
    # Instance variables do not update automatically, so we call this function before anything that needs
    # to check the state of the race variable to make sure it isn't stale
    @race.reload
  end

  def transmit_user(type, msg)
    ws_msg = Api::V1::WebsocketMessage.new(type, message: msg)
    transmit(Api::V1::WebsocketMessageBlueprint.render_as_hash(ws_msg))
  end

  def broadcast_race_update(type, msg)
    update_race_instance
    msg = {
      message: msg,
      race:    Api::V4::RaceBlueprint.render_as_hash(@race, view: @race.type)
    }
    if onsite
      msg[:entrants_html] = ApplicationController.render(partial: 'races/entrants_table', locals: {race: @race})
      msg[:stats_html] = ApplicationController.render(partial: 'races/stats', locals: {race: @race})
    end

    ws_msg = Api::V1::WebsocketMessage.new(type, msg)
    broadcast_to(@race, Api::V1::WebsocketMessageBlueprint.render_as_hash(ws_msg))
  end

  # Starts the race if every entrant is readied up, otherwise does nothing
  def maybe_start_race
    update_race_instance
    return if @race.started? || !@race.entrants.all?(&:ready?) || @race.entrants.count < 2

    @race.update(started_at: Time.now.utc + 20.seconds, status: :in_progress)
    broadcast_race_update('race_start_scheduled', 'Race starting soon')
    GlobalRaceUpdateJob.perform_later('race_started', 'A race has started', @race)
  end

  # Ends the race if all entrants have either finished or forfeited, otherwise does nothing
  def maybe_end_race
    update_race_instance
    return if !@race.started? || !@race.entrants.all?(&:done?)

    @race.update(status: :ended)
    broadcast_race_update('race_ended', 'All entrants have finished')
    GlobalRaceUpdateJob.perform_later('race_finished', 'A race has finished', @race)
  end
end
