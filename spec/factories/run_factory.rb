FactoryBot.define do
  test_files = {
    # factory name:           {filename: 'filename-within-spec/factories/run_files},

    # timer runs
    livesplit14:              {filename: 'livesplit1.4'},
    livesplit15:              {filename: 'livesplit1.5.lss'},
    livesplit16:              {filename: 'livesplit1.6'},
    livesplit16_gametime:     {filename: 'livesplit1.6_gametime.lss'},
    llanfair:                 {filename: 'llanfair'},
    llanfair_gered:           {filename: 'llanfair_gered.lfs'},
    llanfair_gered_with_refs: {filename: 'llanfair_gered_with_refs.lfs'},
    wsplit:                   {filename: 'wsplit'},
    timesplittracker:         {filename: 'timesplittracker.txt'},

    # a bad run and a better run from the same category, against which suggestions can be generated
    compare_subject:          {filename: 'compare_subject.lss'},
    compare_object:           {filename: 'compare_object.lss'},
  }

  test_files.each do |factory_name, file|
    file[:s3_filename] = SecureRandom.uuid
    $s3_bucket_internal.put_object(
      key: "splits/#{file[:s3_filename]}",
      body: File.read("#{Rails.root}/spec/factories/run_files/#{file[:filename]}")
    )
  end

  factory :run do
    s3_filename test_files[:livesplit14][:s3_filename]

    trait :owned do
      user
    end

    trait :unowned do
      user nil
    end

    trait :nicked do
      nick 'boop'
    end

    trait :parsed do
      parsed_at Time.now
      program 'livesplit'
      after(:create) do |run|
        FactoryBot.create_list(:segment, 10, run: run)
      end
      realtime_duration_ms 10000
      realtime_sum_of_best_ms 9000
      realtime_sum_of_best_s 90
    end

    trait :attemptless do
      realtime_duration_ms 0
      realtime_sum_of_best_ms 0
      realtime_sum_of_best_s 0
    end

    test_files.each do |factory_name, file|
      factory("#{factory_name}_run") do
        s3_filename(file[:s3_filename])
      end
    end

    factory :speedrundotcom_run do
      srdc_id 0
    end

    video_url 'http://www.twitch.tv/glacials/c/3463112'
    category
  end
end
