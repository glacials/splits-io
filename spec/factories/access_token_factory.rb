FactoryBot.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    sequence(:resource_owner_id) { |n| n }
    application

    scopes { %i[upload_run delete_run manage_race] }
    expires_in { 2.hours }
  end
end
