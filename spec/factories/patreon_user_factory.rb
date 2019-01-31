FactoryBot.define do
  factory :patreon_user do
    user
    pledge_cents  { 0 }
    access_token  { SecureRandom.uuid }
    refresh_token { SecureRandom.uuid }
    full_name     { SecureRandom.uuid }
    patreon_id    { SecureRandom.uuid }
  end
end
