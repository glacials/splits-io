# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# See https://github.com/rails/rails/issues/35812
ActiveJob::Base.queue_adapter = Rails.application.config.active_job.queue_adapter

Game.create(name: 'Assassin\'s Creed')
Game.create(name: 'Bayonetta')
Game.create(name: 'Celeste')
Game.create(name: 'Cloudbuilt')
Game.create(name: 'Crash Bandicoot')
Game.create(name: 'Diablo 3')
Game.create(name: 'DuckTales: Remastered')
Game.create(name: 'Elite Dangerous')
Game.create(name: 'Event[0]')
Game.create(name: 'Factorio')
Game.create(name: 'Fortnite')
Game.create(name: 'Frostpunk')
Game.create(name: 'Grand Theft Auto V')
Game.create(name: 'Halo')
Game.create(name: 'Half-Life')
Game.create(name: 'Half-Life 2')
Game.create(name: 'ICEY')
Game.create(name: 'Jet Force Gemini')
Game.create(name: 'Ken Follett\'s The Pillars of the Earth')
Game.create(name: 'Life is Strange')
Game.create(name: 'Monster Hunter World')
Game.create(name: 'Necrosphere')
Game.create(name: 'Octopath Traveler')
Game.create(name: 'Portal')
Game.create(name: 'Portal 2')
Game.create(name: 'Quantum Break')
Game.create(name: 'Remember Me')
Game.create(name: 'SpeedRunners')
Game.create(name: 'Starcraft')
Game.create(name: 'Super Mario Sunshine')
Game.create(name: 'The Legend of Zelda: Ocarina of Time')
Game.create(name: 'Tom Clancy\'s Splinter Cell')
Game.create(name: 'Transformers: Fall of Cybertron')
Game.create(name: 'Tron: Evolution')
Game.create(name: 'Uplink')
Game.create(name: 'VVVVVV')
Game.create(name: 'World of Warcraft')
Game.create(name: 'X3: Reunion')
Game.create(name: 'Yoshi\'s Story')
Game.create(name: 'Zeno Clash')
