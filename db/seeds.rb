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

User.create(
  name: 'Alice'
)

Doorkeeper::Application.create(
  name:                'Splits.io',
  uid:                 ENV['SPLITSIO_CLIENT_ID'],
  secret:              ENV['SPLITSIO_CLIENT_SECRET'],
  redirect_uri:        'http://localhost:3000/auth/splitsio/callback',
  scopes:              '',
  owner_id:            2, # First user made after fresh build
  owner_type:          'User',
  secret_generated_at: Time.now,
  confidential:        true,
)

Run.create(s3_filename: SecureRandom.uuid).tap do |run|
  $s3_bucket_internal.put_object(
    key: "splits/#{run.s3_filename}",
    body: File.read("spec/factories/run_files/livesplit1.6_gametime.lss")
  )
  run.parse_into_db
end
