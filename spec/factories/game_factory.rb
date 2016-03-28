FactoryGirl.define do
  factory :game do
    name "The Legend of Mario: Melee Crossing Transformed X/Y 4"

    trait :shortnamed do
      shortname "tlommctxy4"
    end

    trait :with_categories do
      after(:create) do |game|
        FactoryGirl.create_list(:category, 1, game: game)
      end
    end
  end
end
