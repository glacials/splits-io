FactoryGirl.define do
  factory :application, class: Doorkeeper::Application do
    name SecureRandom.uuid
    redirect_uri 'debug'
    association :owner, factory: :user
  end
end
