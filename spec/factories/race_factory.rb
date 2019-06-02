FactoryBot.define do
  factory :race do
    category
    owner factory: :user
  end
end
