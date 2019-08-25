FactoryBot.define do
  factory :user, aliases: %i[runner creator] do
    name { SecureRandom.uuid.split('-')[0] }
    created_at { Time.now }
    updated_at { Time.now }

    after(:create) do |user|
      FactoryBot.create(:twitch_user, user: user)
    end

    trait :with_runs do
      after(:create) do |user|
        FactoryBot.create_list(:run, 3, :parsed, user: user, category: FactoryBot.create(:category))
      end
    end
  end
end
