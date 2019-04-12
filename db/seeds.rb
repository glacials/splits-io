# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# See https://github.com/rails/rails/issues/35812
ActiveJob::Base.queue_adapter = Rails.application.config.active_job.queue_adapter

[
  '.hackInfection',
  '• CONNECTION',
  '2048',
  '3DCube',
  'Assassin\'s Creed',
  'Bayonetta',
  'Celeste',
  'Cloudbuilt',
  'Crash Bandicoot',
  'Diablo 3',
  'DuckTales: Remastered',
  'Elite Dangerous',
  'Event[0]',
  'Factorio',
  'Fortnite',
  'Frostpunk',
  'Grand Theft Auto V',
  'Halo',
  'Half-Life',
  'Half-Life 2',
  'ICEY',
  'Jet Force Gemini',
  'Ken Follett\'s The Pillars of the Earth',
  'Life is Strange',
  'Monster Hunter World',
  'Necrosphere',
  'Octopath Traveler',
  'Portal',
  'Portal 2',
  'Quantum Break',
  'Remember Me',
  'SpeedRunners',
  'Starcraft',
  'Super Mario Sunshine',
  'The Legend of Zelda: Ocarina of Time',
  'Tom Clancy\'s Splinter Cell',
  'Transformers: Fall of Cybertron',
  'Tron: Evolution',
  'Uplink',
  'VVVVVV',
  'World of Warcraft',
  'X3: Reunion',
  'Yoshi\'s Story',
  'Zeno Clash',
].each do |name|
  SpeedrunDotComGame.create(
    game:           Game.create(name: name),
    name:           name,
    default_timing: 'real',
    shortname:      SecureRandom.uuid,
    srdc_id:        SecureRandom.uuid,
    url:            SecureRandom.uuid,
    show_ms:        true
  )
end
