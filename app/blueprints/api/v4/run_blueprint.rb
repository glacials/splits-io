class Api::V4::RunBlueprint < Blueprinter::Base
  fields :srdc_id, :video_url, :program, :attempts, :image_url, :realtime_duration_ms, :gametime_duration_ms,
         :realtime_sum_of_best_ms, :gametime_sum_of_best_ms, :default_timing, :created_at, :updated_at

  field :id do |run, _|
    run.id36
  end

  association :game, blueprint: Api::V4::GameBlueprint
  association :category, blueprint: Api::V4::CategoryBlueprint
  association :segments, blueprint: Api::V4::SegmentBlueprint
  association :histories, blueprint: Api::V4::RunHistoryBlueprint, if: ->(_, _, options) { options[:historic] }
  association :runners, blueprint: Api::V4::UserBlueprint do |run, _|
    ([] << run.user).compact
  end

  # API v4 promises non-null for these fields
  field(:realtime_duration_ms) { |run, _| run.realtime_duration_ms || 0 }
  field(:gametime_duration_ms) { |run, _| run.gametime_duration_ms || 0 }

  view :convert do
    field :id do |_, _|
      nil
    end
  end
end
