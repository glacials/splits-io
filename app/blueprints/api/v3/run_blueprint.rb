class Api::V3::RunBlueprint < Blueprinter::Base
  fields :id, :video_url, :program, :attempts, :image_url, :created_at, :updated_at

  field :name do |run, _|
    run.to_s
  end

  field :path do |run, _|
    "/#{run.id36}"
  end

  field :sum_of_best do |run, _|
    (run.realtime_sum_of_best_ms || 0).to_f / 1000
  end

  field :time do |run, _|
    (run.realtime_duration_ms || 0).to_f / 1000
  end

  association :game, blueprint: Api::V3::GameBlueprint
  association :category, blueprint: Api::V3::CategoryBlueprint
  association :user, blueprint: Api::V3::UserBlueprint
  association :segments, blueprint: Api::V3::SegmentBlueprint, name: :splits, if: ->(_, _, options) { options[:toplevel] == :run }
end
