class Api::V1::GlobalRaceChannel < Api::V1::ApplicationChannel
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

  def update_oauth(data)
    return if check_user

    if (passed_token = data['access_token']).blank?
      transmit_user('oauth_blank_error', 'Must provide oauth token')
      return
    end

    new_token = Doorkeeper::AccessToken.by_token(passed_token)
    if new_token.expired?
      transmit_user('oauth_expired_error', 'This token is no longer valid')
      return
    end

    unless new_token.includes_scope?(:manage_race)
      transmit_user('oauth_scope_error', 'Missing required scope: manage_race')
      return
    end

    if User.find_by(id: new_token.try(:resource_owner_id)) != current_user
      transmit_user('user_mismatch_error', 'Owner of this token does not match connection owner')
      return
    end

    self.oauth_token = new_token
    transmit_user('oauth_updated', 'Your oauth token has been updated')
  end

  def create_race(data)
    return if check_user
    return if check_oauth

    race_type = Raceable.race_from_type(data['race_type'])
    if race_type.nil?
      transmit_user(
        'race_creation_error',
        "Invalid race_type, must be one of: #{Raceable.RACE_TYPES.map(&:to_s).join(', ')}"
      )
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
      race.seed = data['seed'].presence
    end

    race.owner = current_user
    race.visibility = data['visibility'] if race.class.visibilities.key?(data['visibility'])
    race.notes = data['notes']
    if race.save
      race.entrants.create(user: current_user)
      transmit_user(
        'race_creation_success',
        'Race has been created',
        race: Api::V4::RaceBlueprint.render_as_hash(race, view: race.type),
        path: Rails.application.routes.url_helpers.polymorphic_path(race)
      )
      GlobalRaceUpdateJob.perform_later('race_created', 'A new race has been created', race)
    else
      transmit_user(
        'race_creation_error',
        message: race.errors.full_messages.to_sentence
      )
    end
  rescue StandardError => e
    Rails.logger.error([e.message, *e.backtrace].join($RS))
    Rollbar.error(e, 'Uncaught error for Api::V1::GlobalRaceChannel#create_race')
    transmit_user('fatal_error', 'A fatal error occurred while processing your message')
  end
end
