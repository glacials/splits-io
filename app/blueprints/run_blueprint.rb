class RunBlueprint < Blueprinter::Base
  view :default do
    fields :video_url, :program, :attempts, :image_url, :created_at, :updated_at
  end

  view :api_v4 do
    include_view :default

    field :id36, name: :id
    fields :srdc_id, :realtime_duration_ms, :gametime_duration_ms, :default_timing,
           :realtime_sum_of_best_ms, :gametime_sum_of_best_ms

    association :game, blueprint: GameBlueprint, view: :api_v4
    association :category, blueprint: CategoryBlueprint, view: :api_v4
    association :segments, blueprint: SegmentBlueprint, view: :api_v4
    association :histories, blueprint: RunHistoriesBlueprint, view: :api_v4, if: ->(_, options) { options[:toplevel] == :run && options[:historic] }
    association :runners, blueprint: UserBlueprint, view: :api_v4 do |run, _|
      ([] << run.user).compact
    end
  end

  view :api_v4_convert do
    include_view :default

    field :id do |_, _|
      nil
    end

    field :history do |run, _|
      run.histories.order(attempt_number: :asc)
    end

    association :game, blueprint: GameBlueprint, view: :api_v3
    association :category, blueprint: CategoryBlueprint, view: :api_v3
    association :user, blueprint: UserBlueprint, view: :api_v3
    association :segments, blueprint: SegmentBlueprint, name: :splits, view: :api_v3, if: ->(_, options) { options[:toplevel] == :run }
    association :user, blueprint: UserBlueprint, view: :api_v4 do |run, _|
      ([] << run.user).compact
    end
  end

  view :api_v3 do
    include_view :default

    field :id
    field :name do |run, _options|
      run.to_s
    end

    field :path do |run, _options|
      "/#{run.id36}"
    end

    field :sum_of_best do |run, _options|
      (run.realtime_sum_of_best_ms || 0).to_f / 1000
    end

    field :time do |run, _options|
      (run.realtime_duration_ms || 0).to_f / 1000
    end

    association :game, blueprint: GameBlueprint, view: :api_v3
    association :category, blueprint: CategoryBlueprint, view: :api_v3
    association :user, blueprint: UserBlueprint, view: :api_v3
    association :segments, blueprint: SegmentBlueprint, name: :splits, view: :api_v3, if: ->(_, options) { options[:toplevel] == :run }
  end
end
