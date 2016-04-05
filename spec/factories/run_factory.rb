FactoryGirl.define do
  factory :run do
    run_file RunFile.for_file(File.open("#{Rails.root}/spec/factories/run_files/livesplit1.4"))

    trait :owned do
      user
    end

    trait :unowned do
      user nil
    end

    trait :nicked do
      nick 'boop'
    end

    factory :speedrundotcom_run do
      srdc_id 0
    end

    factory :livesplit1_4_run do
      run_file RunFile.for_file(File.open("#{Rails.root}/spec/factories/run_files/livesplit1.4"))
    end

    factory :livesplit1_6_run do
      run_file RunFile.for_file(File.open("#{Rails.root}/spec/factories/run_files/livesplit1.6"))
    end

    factory :llanfair_run do
      run_file RunFile.for_file(File.open("#{Rails.root}/spec/factories/run_files/llanfair"))
    end

    video_url "http://www.twitch.tv/glacials/c/3463112"
  end
end
