FactoryBot.define do
  factory :segment_history do
    segment

    realtime_duration_ms { 1000 }
  end
end
