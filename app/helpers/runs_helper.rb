module RunsHelper
  include ActionView::Helpers::DateHelper

  TIMELINE_CLASSES = %w[blue purple green yellow red orange].freeze

  def difference(run_a, run_b)
    return 0 if run_a.nil? || run_b.nil?
    run_a.duration_ms(Run::REAL) - run_b.duration_ms(Run::REAL)
  end

  def sob_difference(run_a, run_b)
    return 0 if run_a.nil? || run_b.nil?
    run_a.sum_of_best_ms(Run::REAL) - run_b.sum_of_best_ms(Run::REAL)
  end

  def difference_color(time)
    if time.zero?
      'text-primary'
    elsif time.positive?
      'text-danger'
    else
      'text-success'
    end
  end

  def th_sorter(name, param_name)
    p = request.query_parameters.merge(by: param_name, order: th_by(param_name)).to_param

    return link_to(name, "?#{p}", class: th_class(name, param_name)) if params[:by] == param_name

    link_to(name, "?#{p}")
  end

  def th_by(param_name)
    params[:by] == param_name && params[:order] == 'asc' ? 'desc' : 'asc'
  end

  def th_class(name, param_name)
    if params[:by] == param_name
      return link_to(name, "?#{p}", class: params[:order] == 'desc' ? 'headerSortUp' : 'headerSortDown')
    end

    link_to(name, "?#{p}")
  end

  def next_timeline_color(timeline_id, alt: false)
    @next_index = {} if @next_index.blank?

    if @next_index[timeline_id].blank?
      @next_index[timeline_id] = 0
    else
      @next_index[timeline_id] = (@next_index[timeline_id] + 1) % TIMELINE_CLASSES.length
    end

    TIMELINE_CLASSES[@next_index[timeline_id]]
  end

  def pretty_timestamp(timestamp)
    "<span title=\"#{timestamp}\">#{time_ago_in_words(timestamp)} ago</span>".html_safe
  end

  def pretty_duration(seconds)
    ms = (seconds * 1000).floor

    "<span class=\"text-default\">#{Duration.new(ms).format}</span>".html_safe
  end

  def pretty_difference(my_ms, their_ms)
    diff_ms = (my_ms - their_ms)

    return "<span class=\"text-success\">-#{Duration.new(diff_ms.abs).format_casual}</span>".html_safe if diff_ms.negative?

    return "<span class=\"text-danger\">+#{Duration.new(diff_ms).format_casual}</span>".html_safe if diff_ms.positive?

    "<span class=\"text-warning\">+#{Duration.new(diff_ms).format_casual}</span>".html_safe
  end

  # format_ms is deprecated. Use Duration.new(milliseconds).format instead.
  def format_ms(milliseconds, precise: false)
    Duration.new(milliseconds).format(precise: precise)
  end

  # format_ms_casual is deprecated. Use Duration.new(milliseconds).format_casual instead.
  def format_ms_casual(milliseconds, num_units = 2)
    Duration.new(milliseconds).format_casual(num_units: num_units)
  end

  def sorting_info
    {
      page: params[:page] || 1,
      order: [
        params[:by],
        params[:order]
      ]
    }
  end
end
