FactoryBot.define do
  factory :user do
    name { SecureRandom.uuid }

    after(:create) do |user|
      FactoryBot.create(:twitch_user, user: user)
    end

    trait :with_runs do
      after(:create) do |user|
        FactoryBot.create_list(:run, 3, user: user, category: FactoryBot.create(:category))
      end
    end
  end
end
