FactoryBot.define do
  factory :twitch_user, aliases: %i[twitch] do
    access_token { SecureRandom.uuid }
    avatar       { SecureRandom.uuid }
    display_name { SecureRandom.uuid }
    name         { SecureRandom.uuid }
    twitch_id    { SecureRandom.uuid }
    url          { SecureRandom.uuid }

    after(:build) do |twitch_user|
      twitch_user.user ||= FactoryBot.build(:user, twitch: twitch_user)
    end
  end
end
