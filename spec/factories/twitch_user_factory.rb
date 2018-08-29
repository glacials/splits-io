FactoryBot.define do
  factory :twitch_user do
    user
    name         { SecureRandom.uuid }
    display_name { SecureRandom.uuid }
    avatar       { SecureRandom.uuid }
    twitch_id    { SecureRandom.uuid }
    access_token { SecureRandom.uuid }
  end
end
