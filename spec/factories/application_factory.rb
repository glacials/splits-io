FactoryBot.define do
  factory :application, class: Doorkeeper::Application do
    association :owner, factory: :user

    name         { SecureRandom.uuid }
    redirect_uri { 'debug' }
  end
end
