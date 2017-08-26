FactoryGirl.define do
  factory :game do
    name 'The Legend of Mario: Melee Crossing Transformed X/Y 4'

    trait :shortnamed do
      shortname 'tlommctxy4'
    end

    trait :with_categories do
      after(:create) do |game|
        FactoryGirl.create_list(:category, 1, game: game)
      end
    end

    trait :with_runs do
      after(:create) do |game|
        FactoryGirl.create_list(:run, 3, :parsed, category: FactoryGirl.create(:category, game: game))
      end
    end
  end
end
