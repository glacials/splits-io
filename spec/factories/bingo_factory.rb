FactoryBot.define do
  factory :bingo do
    game
    owner factory: :user
  end
end
