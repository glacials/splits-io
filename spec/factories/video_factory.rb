FactoryBot.define do
  factory :video do
    for_run

    url { 'http://www.twitch.tv/glacials/c/3463112' }

    trait :for_run do
      association(:videoable, factory: :run)
    end
  end
end
