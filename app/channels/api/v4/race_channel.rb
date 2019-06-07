class Api::V4::RaceChannel < Api::V4::ApplicationChannel
  def subscribed
    @race = Raceable.race_from_type(params[:race_type]).find_by(id: params[:race_id])
    if @race.nil?
      transmit_user('race_not_found', "No race found with id: #{params[:race_id]}")
      reject
      return
    end

    if @race.secret_visibility? && !@race.joinable?(user: current_user, token: params[:join_token])
      transmit_user('race_invalid_join_token', 'The join token provided is not valid for this race')
      reject
    else
      stream_for(@race)
      stream_from("api:v4:race:#{@race.to_gid_param}:onsite") if onsite
      return unless params[:state] == '1'

      ws_msg = Api::V4::WebsocketMessage.new(
        'race_state',
        message: 'Race state',
        race:    Api::V4::RaceBlueprint.render_as_hash(@race, view: @race.type, chat: true)
      )

      transmit(Api::V4::WebsocketMessageBlueprint.render_as_hash(ws_msg))
    end
  end

  def unsubscribed
    stop_all_streams
  end

  private

  def update_race_instance
    # Instance variables do not update automatically, so we call this function before anything that needs
    # to check the state of the race variable to make sure it isn't stale
    @race.reload
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

      if @race.randomizer?
        msg[:attachments_html] = ApplicationController.render(partial: 'races/attachments', locals: {race: @race})
      end
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
