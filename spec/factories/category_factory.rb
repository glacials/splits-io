FactoryBot.define do
  factory :category do
    game
    name 'Any%'

    trait :with_runs do
      after(:create) do |category|
        FactoryBot.create_list(:run, 3, category: category)
      end
    end

    trait :with_runners do
      after(:create) do |category|
        FactoryBot.create_list(:run, 3, :owned, category: category)
      end
    end
  end
end
