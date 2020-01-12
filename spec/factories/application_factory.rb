FactoryBot.define do
  factory :application, class: Doorkeeper::Application do
    association :owner, factory: :user

    name         { SecureRandom.uuid }
    redirect_uri { 'https://localhost:3000/' }
  end
end
