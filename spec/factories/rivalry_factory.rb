FactoryGirl.define do
  factory :rivalry do
    association :from_user, factory: :user
    association :to_user, factory: :user
    category

    after(:create) do |rivalry|
      FactoryGirl.create(:run, :parsed, category: rivalry.category, user: rivalry.from_user)
      FactoryGirl.create(:run, :parsed, category: rivalry.category, user: rivalry.to_user)
    end
  end
end
