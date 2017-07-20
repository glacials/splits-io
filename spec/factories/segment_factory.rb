FactoryGirl.define do
  factory :segment do
    run
    name SecureRandom.uuid
    segment_number 0
    realtime_start_ms 0
    realtime_end_ms 1000
    realtime_duration_ms 1000
    realtime_shortest_duration_ms 1000
    realtime_gold true
    realtime_reduced false
    realtime_skipped false

    after(:create) do |segment|
      FactoryGirl.create_list(:segment_history, 10, segment: segment)
    end
  end
end
