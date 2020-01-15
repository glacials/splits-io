# Sync all srdc games, categories, and variables

require 'httparty'

SRDC_REGIONS_URL   = 'https://www.speedrun.com/api/v1/regions?max=200'.freeze
SRDC_PLATFORMS_URL = 'https://www.speedrun.com/api/v1/platforms?max=200'.freeze
SRDC_GAMES_URL     = 'https://www.speedrun.com/api/v1/games?embed=categories,variables,regions,platforms&max=200'.freeze

desc 'Sync all games, categories, and variable data from srdc'
task srdc_sync: [:environment] do
  url = SRDC_PLATFORMS_URL
  loop do
    puts url
    platforms = HTTParty.get(url, headers: {'User-Agent' => 'Splits.io-Sync/1.0'})
    platforms['data'].each do |region|
      SpeedrunDotComPlatform.find_or_create_by!(
        srdc_id: region['id'],
        name:    region['name']
      )
    end

    old_url = url
    platforms['pagination']['links'].each do |l|
      next unless l['rel'] == 'next'

      url = l['uri']
      break
    end
    break if old_url == url
  end

  url = SRDC_REGIONS_URL
  loop do
    puts url
    regions = HTTParty.get(url, headers: {'User-Agent' => 'Splits.io-Sync/1.0'})
    regions['data'].each do |region|
      SpeedrunDotComRegion.find_or_create_by!(
        srdc_id: region['id'],
        name:    region['name']
      )
    end

    old_url = url
    regions['pagination']['links'].each do |l|
      next unless l['rel'] == 'next'

      url = l['uri']
      break
    end
    break if old_url == url
  end

  url = SRDC_GAMES_URL
  # Disable SQL logging (might only need for prod)
  # ActiveRecord::Base.logger.level = :info

  loop do
    puts url
    games = HTTParty.get(url, headers: {'User-Agent' => 'Splits.io-Sync/1.0'})
    break if games['data'].empty?

    # TODO: Handle these exceptions better
    games['data'].each do |game|
      next if game['categories']['data'].all? { |category| category['type'] == 'per-level' }

      if game['names']['international'] == 'God of War' && game['released'] == 2018
        # srdc_id == 'k6qx9z1g'
        game['names']['international'] = 'God of War (2018)'
      end

      if game['names']['international'] == 'Golden Axe' && game['released'] == 1990
        # srdc_id == '4d79oor1'
        game['names']['international'] = 'Golden Axe (Amiga)'
      end

      next if game['id'] == 'k6qx9z1g'
      next if game['id'] == '9d3rq4wd'
      next if game['id'] == 'm1zj70z6'
      next if game['id'] == 'lde3ynj6'

      game['names']['international'] = 'Point Blank (2017)' if game['id'] == '3dx4w56y'
      game['names']['international'] = 'Road Rash (1994)' if game['id'] == 'm1mxzvk6'
      # TODO: Use AR-import instead of individual calls
      srdc_game = SpeedrunDotComGame.find_or_initialize_by(srdc_id: game['id'])
      srdc_game.assign_attributes(
        name:              game['names']['international'],
        twitch_name:       game['names']['twitch'],
        shortname:         game['abbreviation'],
        url:               game['weblink'],
        favicon_url:       game['assets']['icon']['uri'],
        cover_url:         game['assets']['cover-large']['uri'],
        default_timing:    game['ruleset']['default-time'] == 'ingame' ? 'game' : 'real',
        show_ms:           game['ruleset']['show-milliseconds'],
        video_required:    game['ruleset']['require-video'],
        accepts_realtime:  game['ruleset']['run-times'].include?('realtime'),
        accepts_gametime:  game['ruleset']['run-times'].include?('gametime'),
        emulators_allowed: game['ruleset']['emulators-allowed']
      )
      srdc_game.game = Game.find_or_create_by!(name: srdc_game.name) if srdc_game.game.nil?
      srdc_game.save!

      game['categories']['data'].each do |category|
        next if category['type'] == 'per-level'

        srdc_category = SpeedrunDotComCategory.find_or_initialize_by(srdc_id: category['id'])
        srdc_category.assign_attributes(
          name:        category['name'],
          url:         category['weblink'],
          misc:        category['miscellaneous'],
          rules:       category['rules'],
          min_players: category['players']['type'] == 'up-to' ? 1 : category['players']['value'],
          max_players: category['players']['value']
        )
        srdc_category.category = Category.find_or_create_by!(
          game: srdc_game.game,
          name: srdc_category.name
        )
        srdc_category.save!
      end

      game['platforms']['data'].each do |platform|
        SpeedrunDotComGamePlatform.find_or_create_by!(
          speedrun_dot_com_game:     srdc_game,
          speedrun_dot_com_platform: SpeedrunDotComPlatform.find_by!(srdc_id: platform['id'])
        )
      end

      game['regions']['data'].each do |region|
        SpeedrunDotComGameRegion.find_or_create_by!(
          speedrun_dot_com_game:   srdc_game,
          speedrun_dot_com_region: SpeedrunDotComRegion.find_by!(srdc_id: region['id'])
        )
      end

      game['variables']['data'].each do |variable|
        next unless ['full-game', 'global'].include?(variable['scope']['type'])

        srdc_variable = SpeedrunDotComGameVariable.find_or_initialize_by(srdc_id: variable['id'])
        srdc_variable.name                      = variable['name']
        srdc_variable.speedrun_dot_com_game     = srdc_game
        srdc_variable.speedrun_dot_com_category = SpeedrunDotComCategory.find_by(srdc_id: variable['category'])
        srdc_variable.mandatory                 = variable['mandatory']
        srdc_variable.obsoletes                 = variable['obsoletes']
        srdc_variable.user_defined              = variable['user-defined']
        srdc_variable.game_scope                = variable['scope']['type']
        srdc_variable.save!

        variable['values']['values'].each do |key, value|
          srdc_variable_value = SpeedrunDotComGameVariableValue.find_or_initialize_by(srdc_id: key)
          srdc_variable_value.speedrun_dot_com_game_variable = srdc_variable
          srdc_variable_value.label                          = value['label']
          srdc_variable_value.rules                          = value['rules']
          srdc_variable_value.miscellaneous                  = value.dig('flags', 'miscellaneous')
          srdc_variable_value.save!

          srdc_variable.update!(default_value: srdc_variable_value) if variable['values']['default'] == key
        end
      end
    end

    # 100 req/min throttle rate
    # Simple sleep is easier than trying to calculate processing times
    sleep(0.6)

    old_url = url
    games['pagination']['links'].each do |l|
      next unless l['rel'] == 'next'

      url = l['uri']
      break
    end
    break if old_url == url
  end
end
