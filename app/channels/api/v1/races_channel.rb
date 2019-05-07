class Api::V1::RacesChannel < ApplicationCable::Channel
  def subscribed
    @race = Raceable.race_from_type(params[:race_type]).find_by(id: params[:race_id])
    reject if @race.nil?

    if (@race.invite_only? || @race.secret?) && @race.auth_token != params[:auth_token]
      reject
    else
      stream_for(@race)
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def join
    return if current_user.nil?

    update_race_instance
    if @race.started?
      transmit_user('race_started_error', 'The race has already started')
      return
    end

    if ability.cannot?(:join, @race)
      transmit_user('race_join_error', 'Please make sure you are not in another race')
      return
    end

    entrant = Entrant.new(raceable: @race, user: current_user)
    if entrant.save
      transmit_user('race_join_success', 'Race successfully joined')
      broadcast_race_update('race_entrants_updated', 'A new entrant has join the race')
    else
      transmit_user('race_join_error', entrant.errors.full_messages.to_sentence)
    end
  end

  def leave
    return if current_user.nil?

    update_race_instance
    if @race.started?
      transmit_user('race_started_error', 'The race has already started')
      return
    end

    entrant = Entrant.find_by(raceable: @race, user: current_user)
    return if entrant.nil?

    if entrant.destroy
      transmit_user('race_leave_success', 'Race successfully left')
      broadcast_race_update('race_entrants_updated', 'An entrant has left the race')
    else
      transmit_user('race_part_error', entrant.error.full_messages.to_sentence)
    end
  end

  def ready
    return if current_user.nil?

    update_race_instance
    if @race.started?
      transmit_user('race_started_error', 'Cannot ready for race in progress')
      return
    end

    entrant = Entrant.find_by(raceable: @race, user: current_user)
    return if entrant.nil?

    if entrant.update(ready: true)
      transmit_user('race_ready_success', 'Entrant ready successful')
      broadcast_race_update('race_entrants_updated', 'An entrant has readied up')
      maybe_start_race
    else
      transmit_user('race_ready_error', entrant.errors.full_messages.to_sentence)
    end
  end

  def unready
    return if current_user.nil?

    update_race_instance
    if @race.started?
      transmit_user('race_started_error', 'Cannot unready for race in progress')
      return
    end

    entrant = Entrant.find_by(raceable: @race, user: current_user)
    return if entrant.nil?

    if entrant.update(ready: false)
      transmit_user('race_unready_success', 'Entrant unready successful')
      broadcast_race_update('race_entrants_updated', 'An entrant has unreadied')
    else
      transmit_user('race_unready_error', entrant.errors.full_messages.to_sentence)
    end
  end

  def forfeit(data)
    # Immediately take a timestamp in case there is no server time passed in
    # This is to try and make sure ff's have the most accurate time
    forfeit_time = Time.now.utc
    forfeit_time = Time.at(data['server_time']).utc if data['server_time'].present?
    return if current_user.blank?

    update_race_instance
    unless @race.started?
      transmit_user('race_started_error', 'Cannot abandon race that is not in progress')
      return
    end

    if @race.finished?
      transmit_user('race_finished_error', 'Cannot finish in a race that is already finished')
      return
    end

    entrant = Entrant.find_by(raceable: @race, user: current_user)
    return if entrant.nil?

    if entrant.update(forfeited_at: forfeit_time)
      transmit_user('race_forfeit_success', 'Entrant forfeit successful')
      broadcast_race_update('race_entrants_updated', 'An entrant has forfeited')
      maybe_end_race
    else
      transmit_user('race_abandon_error', entrant.errors.full_messages.to_sentence)
    end
  end

  def done(data)
    # Immediately take a timestamp in case there is no server time passed in
    # This is to try and make sure done's have the most accurate time
    done_time = Time.now.utc
    done_time = Time.at(data['server_time']).utc if data['server_time'].present?
    return if current_user.nil?

    update_race_instance
    unless @race.started?
      transmit_user('race_started_error', 'Cannot finish in a race that is not started')
      return
    end

    if @race.finished?
      transmit_user('race_finished_error', 'Cannot finish in a race that is already finished')
      return
    end

    entrant = Entrant.find_by(raceable: @race, user: current_user)
    return if entrant.nil?

    if entrant.update(finished_at: done_time)
      transmit_user('race_done_success', 'Entrant done successful')
      broadcast_race_update('race_entrants_updated', 'An entrant has finished')
      maybe_end_race
    else
      transmit_user('race_done_error', entrant.errors.full_messages.to_sentence)
    end
  end

  def rejoin
    return if current_user.nil?

    update_race_instance
    unless @race.started?
      transmit_user('race_started_error', 'Cannot rejoin race that is not in progress')
      return
    end

    if @race.finished?
      transmit_user('race_finished_error', 'Cannot rejoin race that has already finished')
      return
    end

    entrant = Entrant.find_by(raceable: @race, user: current_user)
    return if entrant.nil?

    if entrant.update(finished_at: nil, forfeited_at: nil)
      transmit_user('race_rejoin_success', 'Entrant rejoin successful')
      broadcast_race_update('race_entrants_updated', 'An entrant has rejoined the race')
    else
      transmit_user('race_rejoin_error', entrant.errors.full_messages.to_sentence)
    end
  end

  private

  def update_race_instance
    # Instance variables do not update automatically, so we call this function before anything that needs
    # to check the state of the race variable to make sure it isn't stale
    @race.reload
  end

  def transmit_user(type, msg)
    transmit({
      type: type,
      data: {
        message: msg
      }
    })
  end

  def broadcast_race_update(type, msg)
    update_race_instance
    msg = {
      type: type,
      data: {
        message: msg,
        race:    Api::V4::RaceBlueprint.render_as_hash(@race)
      }
    }
    msg[:entrants_html] = ApplicationController.render(partial: 'races/entrants_table', locals: {race: @race}) if onsite

    broadcast_to(@race, msg)
  end

  # Starts the race if every entrant is readied up, otherwise does nothing
  def maybe_start_race
    update_race_instance
    return if @race.started? || !@race.entrants.all(&:ready) || @race.entrants.count < 2

    @race.update(started_at: Time.now.utc + 20.seconds, status_text: Raceable::IN_PROGRESS)
    broadcast_race_update('race_start_scheduled', 'Race starting soon')
  end

  # Ends the race if all entrants have either finished or forfeited, otherwise does nothing
  def maybe_end_race
    update_race_instance
    return if !@race.started? || !@race.entrants.all?(&:done?)

    @race.update(status_text: Raceable::ENDED)
    broadcast_race_update('race_ended', 'All entrants have finished')
  end
end
