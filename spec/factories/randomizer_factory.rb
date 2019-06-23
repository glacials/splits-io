FactoryBot.define do
  factory :randomizer do
    game
    owner factory: :user
  end
end
