FactoryGirl.define do
  livesplit_1_4 = SecureRandom.uuid
  $s3_bucket.put_object(
    key: "splits/#{livesplit_1_4}",
    body: File.read("#{Rails.root}/spec/factories/run_files/livesplit1.4")
  )

  livesplit_1_6 = SecureRandom.uuid
  $s3_bucket.put_object(
    key: "splits/#{livesplit_1_6}",
    body: File.read("#{Rails.root}/spec/factories/run_files/livesplit1.6")
  )

  llanfair = SecureRandom.uuid
  $s3_bucket.put_object(
    key: "splits/#{llanfair}",
    body: File.read("#{Rails.root}/spec/factories/run_files/llanfair")
  )

  llanfair_gered = SecureRandom.uuid
  $s3_bucket.put_object(
    key: "splits/#{llanfair_gered}",
    body: File.read("#{Rails.root}/spec/factories/run_files/llanfair_gered.lfs")
  )

  llanfair_gered_with_refs = SecureRandom.uuid
  $s3_bucket.put_object(
    key: "splits/#{llanfair_gered_with_refs}",
    body: File.read("#{Rails.root}/spec/factories/run_files/llanfair_gered_with_refs.lfs")
  )

  wsplit = SecureRandom.uuid
  $s3_bucket.put_object(
    key: "splits/#{wsplit}",
    body: File.read("#{Rails.root}/spec/factories/run_files/wsplit")
  )

  factory :run do
    s3_filename livesplit_1_4

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
      s3_filename livesplit_1_4
    end

    factory :livesplit1_6_run do
      s3_filename livesplit_1_6
    end

    factory :llanfair_run do
      s3_filename llanfair
    end

    factory :llanfair_gered_run do
      s3_filename llanfair_gered
    end

    factory :llanfair_gered_run_with_refs do
      s3_filename llanfair_gered_with_refs
    end

    factory :wsplit_run do
      s3_filename wsplit
    end

    video_url 'http://www.twitch.tv/glacials/c/3463112'
  end
end
