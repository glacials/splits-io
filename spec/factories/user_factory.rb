FactoryGirl.define do
  factory :user do
    name SecureRandom.uuid
    twitch_id 0

    trait :with_runs do
      after(:create) do |user|
        FactoryGirl.create_list(:run, 3, user: user, category: FactoryGirl.create(:category))
      end
    end
  end
end
