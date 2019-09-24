FactoryBot.define do
  test_files = {
    # factory name:           {filename: 'filename-within-spec/factories/run_files},

    # timer runs
    livesplit14:              {filename: 'livesplit1.4'},
    livesplit15:              {filename: 'livesplit1.5.lss'},
    livesplit16:              {filename: 'livesplit1.6'},
    livesplit16_gametime:     {filename: 'livesplit1.6_gametime.lss'},
    livesplit_no_realtime:    {filename: 'livesplit_no_realtime.lss'},
    llanfair:                 {filename: 'llanfair'},
    llanfair_gered:           {filename: 'llanfair_gered.lfs'},
    llanfair_gered_with_refs: {filename: 'llanfair_gered_with_refs.lfs'},
    splitsio_exchange:        {filename: 'splitsio_exchange/b.json'},
    wsplit:                   {filename: 'wsplit'},
    timesplittracker:         {filename: 'timesplittracker.txt'},

    # a bad run and a better run from the same category, against which suggestions can be generated
    compare_subject:          {filename: 'compare_subject.lss'},
    compare_object:           {filename: 'compare_object.lss'},

    # specific-content runs
    with_segments_bests:      {filename: 'with_segments_bests.lss'},

    # skipped splits
    skipped_splits:           {filename: 'livesplit_skipped_splits.lss'},
  }

  test_files.each do |_factory_name, file|
    file[:s3_filename] = SecureRandom.uuid
    $s3_bucket_internal.put_object(
      key: "splits/#{file[:s3_filename]}",
      body: File.read("#{Rails.root}/spec/factories/run_files/#{file[:filename]}")
    )
  end

  factory :run do
    category

    s3_filename { test_files[:livesplit14][:s3_filename] }

    trait :owned do
      user
    end

    trait :unowned do
      user { nil }
    end

    trait :nicked do
      nick { 'boop' }
    end

    trait :parsed do
      parsed_at { Time.now.utc }
      program   { 'livesplit' }

      realtime_duration_ms    { 10_000 }
      realtime_sum_of_best_ms { 9000 }
      total_playtime_ms       { 10_000 }

      after(:create) do |run|
        FactoryBot.create_list(:segment, 10, run: run, segment_number: rand(1..10))
      end
    end

    trait :attemptless do
      realtime_duration_ms    { 0 }
      realtime_sum_of_best_ms { 0 }
    end

    trait :with_video do
      video { |instance| FactoryBot.build(:video, run: instance) }
    end

    factory :speedrundotcom_run do
      srdc_id { 0 }
    end

    test_files.each do |factory_name, file|
      factory("#{factory_name}_run") do
        s3_filename { file[:s3_filename] }
      end
    end
  end
end
