class Api::V1::GlobalRaceChannel < ApplicationCable::Channel
  def subscribed
    stream_from('v1:global_channel')
    stream_from('v1:global_updates_channel') if params[:updates] == '1'
    return unless params[:state] == '1'

    ws_msg = Api::V1::WebsocketMessage.new(
      'global_state',
      message:     'Global race state',
      races:       Api::V4::RaceBlueprint.render_as_hash(Race.active, view: :race),
      bingos:      Api::V4::RaceBlueprint.render_as_hash(Bingo.active, view: :bingo),
      randomizers: Api::V4::RaceBlueprint.render_as_hash(Randomizer.active, view: :randomizer)
    )
    transmit(ws_msg)
  end

  def unsubscribed
    stop_all_streams
  end

  def create_race(data)
    if current_user.nil?
      transmit(Api::V1::WebsocketMessageBlueprint.render_as_hash(Api::V1::WebsocketMessage.new(
        'race_creation_error',
        message: 'Must be authenticated as a user to make a race (you are anonymous)'
      )))
      return
    end

    race_type = Raceable.race_from_type(data['race_type'])
    if race_type.nil?
      ws_msg = Api::V1::WebsocketMessage.new(
        'race_creation_error',
        message: "Invalid race_type, must be one of: #{Raceable.RACE_TYPES.map(&:to_s).join(', ')}"
      )
      transmit(Api::V1::WebsocketMessageBlueprint.render_as_hash(ws_msg))
      return
    end

    race = race_type.new
    case race
    when Race
      category = Category.find_by(id: data['category_id'])

      race.category = category
    when Bingo
      game = Game.find_by(id: data['game_id'])

      race.game = game
      race.card_url = data['bingo_card']
    when Randomizer
      game = Game.find_by(id: data['game_id'])

      race.game = game
      race.seed = data['seed']
    end

    race.owner = current_user
    race.visibility = data['visibility'] if race.class.visibilities.key?(data['visibility'])
    race.notes = data['notes']
    if race.save
      race.entrants.create(user: current_user)
      ws_msg = Api::V1::WebsocketMessage.new(
        'race_creation_success',
        message: 'Race has been created',
        race:    Api::V4::RaceBlueprint.render_as_hash(race, view: race.type),
        path:    Rails.application.routes.url_helpers.polymorphic_path(race)
      )
      GlobalRaceUpdateJob.perform_later('race_created', 'A new race has been created', race)
    else
      ws_msg = Api::V1::WebsocketMessage.new(
        'race_creation_error',
        message: race.errors.full_messages.to_sentence
      )
    end
    transmit(Api::V1::WebsocketMessageBlueprint.render_as_hash(ws_msg))
  rescue StandardError => e
    Rollbar.error(e, 'Uncaught error for Api::V1::GlobalRaceChannel#create_race')
    transmit_user('fatal_error', 'A fatal error occurred while processing your message')
  end
end
