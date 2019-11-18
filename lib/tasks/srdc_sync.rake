# Sync all srdc games, categories, and variables

require 'httparty'

SRDC_URL = 'https://www.speedrun.com/api/v1/games?embed=categories,variables,regions,platforms&max=200'.freeze

desc 'Sync all games, categories, and variable data from srdc'
task srdc_sync: [:environment] do
  url = SRDC_URL
  # Disable SQL logging
  ActiveRecord::Base.logger.level = :info

  loop do
    puts url
    games = HTTParty.get(url, headers: {'User-Agent' => 'Splits.io-Sync/1.0'})
    break if games['data'].empty?

    games['data'].each do |game|
      srdc_game = Game.find_or_initialize_by(srdc_id: game['id'])
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
        accepts_realtime:  game['ruleset']['run-times'].includes?('realtime'),
        accepts_gametime:  game['ruleset']['run-times'].includes?('gametime'),
        emulators_allowed: game['ruleset']['emulators-allowed']
      )
      srdc_game.game = Game.find_or_create_by!(name: srdc_game.name) if srdc_game.game.nil?
      srdc_game.save!

      game['categories']['data'].each do |category|
        srdc_category = Category.find_or_initialize_by(srdc_id: category['id'])
        srdc_category.assign_attributes(
          name:        category['name'],
          url:         category['weblink'],
          misc:        category['miscellaneous'],
          rules:       category['rules'],
          min_players: category['players']['type'] == 'up-to' ? 1 : result['players']['value'],
          max_players: category['players']['value']
        )
        srdc_category.category = Category.find_or_create_by!(game: srdc.game, name: srdc_category.name)
        srdc_category.save!
      end

      %w[platforms regions].each do |variable|
        srdc_variable = SpeedrunDotComGameVariable.find_or_initialize_by(
          speedrun_dot_com_game: srdc_game,
          type:                  variable
        )
        srdc_variable.name = variables[0...-1].capitalize
        srdc_variable.save!

        game[variable]['data'].each do |data|
          srdc_variable_value = SpeedrunDotComGameVariableValue.find_or_initialize_by(srdc_id: data['id'])
          srdc_variable_value.speedrun_dot_com_game = srdc_game
          srdc_variable_value.label                 = data['name']
        end
      end

      game['variables']['data'].each do |variable|
        srdc_variable = SpeedrunDotComGameVariable.find_or_initialize_by(
          type:    'variables',
          srdc_id: data['id']
        )
        srdc_variable.name                      = variable['name']
        srdc_variable.speedrun_dot_com_game     = srdc_game
        srdc_variable.speedrun_dot_com_category = SpeedrunDotComCategory.find_by(srdc_id: variable['category'])
        srdc_variable.mandatory                 = variable['mandatory']
        srdc_variable.obsoletes                 = variable['obsoletes']
        srdc_variable.user_defined              = variable['user-defined']
        srdc_variable.save!

        variable['values']['values'].each do |key, value|
          srdc_variable_value = SpeedrunDotComGameVariableValue.find_or_initialize_by(srdc_id: key)
          srdc_variable_value.speedrun_dot_com_game = srdc_game
          srdc_variable_value.label                 = value['label']
          srdc_variable_value.rules                 = value['rules']
          srdc_variable_value.miscellaneous         = value['flags']['miscellaneous']
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
