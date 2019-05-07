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
      return if data['category_id'].blank?

      category = Category.find_by(id: data['category_id'])
      return if category.nil?

      race.category = category
    when BingoRace
      return if data['game_id'].blank?
      return if data['bingo_card'].blank?

      game = Game.find_by(id: data['game_id'])
      return if game.nil?

      race.game = game
      race.card = data['bingo_card']
    when RandomizerRace
      return if data['game_id'].blank?
      return if data['seed'].blank?

      game = Game.find_by(id: data['game_id'])
      return if game.nil?

      race.game = game
      race.seed = data['seed']
    end

    race.owner = current_user
    race.status_text = Raceable::OPEN
    race.visibility!(data['visibility'])
    race.notes = data['notes'] if data['notes'].present?
    if race.save
      transmit({
        type: 'race_creation_successful',
        data: {
          message: 'Race has been created',
          race:    Api::V4::RaceBlueprint.render_as_hash(race),
          path:    Rails.application.routes.url_helpers.race_path(*race.url_params)
        }
      })
    else
      transmit({
        type: 'race_creation_error',
        data: {
          message: race.errors.full_messages.to_sentence
        }
      })
    end
  end
end
