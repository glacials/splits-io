FactoryBot.define do
  factory :speedrun_dot_com_game do
    game

    srdc_id        { SecureRandom.uuid }
    url            { 'https://speedrun.com/sms' }
    default_timing { 'real' }
    show_ms        { true }
    name           { 'The Legend of Mario: Melee Crossing Transformed X/Y 4' }
  end
end
