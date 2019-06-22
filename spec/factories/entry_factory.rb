FactoryBot.define do
  factory :entry do
    user
    for_race

    trait :for_race do
      raceable factory: :race
    end

    trait :for_bingo do
      raceable factory: :bingo
    end

    trait :randomizer do
      raceable factory: :randomizer
    end
  end
end
