class Api::V1::GlobalRaceChannel < ApplicationCable::Channel
  def subscribed
    stream_from('global_channel')
  end

  def unsubscribed
    stop_all_streams
  end

  def create_race(data)
    return if current_user.blank?
    return if data['race_type'].blank?

    race_type = Raceable.race_from_type(data['race_type'])
    return if race_type.nil?

    race = race_type.new
    case race
    when StandardRace
      category = Category.find_by(id: data['category_id'])

      race.category = category
    when BingoRace
      game = Game.find_by(id: data['game_id'])

      race.game = game
      race.card = data['bingo_card']
    when RandomizerRace
      game = Game.find_by(id: data['game_id'])

      race.game = game
      race.seed = data['seed']
    end

    race.owner = current_user
    race.status_text = Raceable::OPEN_ENTRY
    race.visibility = data['visibility'] if race.class.visibilities.key?(data['visibility'])
    race.notes = data['notes']
    if race.save
      ws_msg = Api::V1::WebsocketMessage.new(
        'race_creation_success',
        message: 'Race has been created',
        race:    Api::V4::RaceBlueprint.render_as_hash(race),
        path:    Rails.application.routes.url_helpers.race_path(*race.url_params)
      )
      transmit(Api::V1::WebsocketMessageBlueprint.render_as_hash(ws_msg))
    else
      ws_msg = Api::V1::WebsocketMessage.new(
        'race_creation_error',
        message: race.errors.full_messages.to_sentence
      )
      transmit(Api::V1::WebsocketMessageBlueprint(ws_msg))
    end
  end
end
