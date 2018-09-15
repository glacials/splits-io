module RunsHelper
  include ActionView::Helpers::DateHelper

  TIMELINE_COLORS = %i[blue purple green yellow red orange].freeze

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

  def next_timeline_color(timeline_id)
    @next_index = {} if @next_index.blank?

    @next_index[timeline_id] = if @next_index[timeline_id].blank?
                                 0
                               else
                                 (@next_index[timeline_id] + 1) % TIMELINE_COLORS.length
                               end

    TIMELINE_COLORS[@next_index[timeline_id]]
  end

  def pretty_timestamp(timestamp)
    "<span title=\"#{timestamp}\">#{time_ago_in_words(timestamp)} ago</span>".html_safe
  end

  def pretty_duration(seconds)
    ms = (seconds * 1000).floor

    "<span class=\"text-default\">#{format_ms(ms)}</span>".html_safe
  end

  def pretty_difference(my_ms, their_ms)
    diff_ms = (my_ms - their_ms)

    return "<span class=\"text-success\">-#{format_ms_casual(diff_ms.abs)}</span>".html_safe if diff_ms.negative?

    return "<span class=\"text-danger\">+#{format_ms_casual(diff_ms)}</span>".html_safe if diff_ms.positive?

    "<span class=\"text-warning\">+#{format_ms_casual(diff_ms)}</span>".html_safe
  end

  # format_ms accepts a number of milliseconds and returns a time like "HH:MM:SS". If precise is true, it returns a time
  # like "HH:MM:SS.mmm" instead.
  def format_ms(milliseconds, precise: false)
    return '-' if milliseconds.nil?
    time = explode_ms(milliseconds)

    return format('%02d:%02d:%02d.%03d', time[:h], time[:m], time[:s], time[:ms]) if precise
    format('%02d:%02d:%02d', time[:h], time[:m], time[:s])
  end

  # format_ms_casual returns a string like "3m 2s" from a given duration in milliseconds. num_units specifies how many
  # unit types to display, e.g. a num_units of 3 will show something like "3m 2s 123ms". Returned times are truncated,
  # not rounded.
  def format_ms_casual(milliseconds, num_units = 2)
    return '-' if milliseconds.nil? || milliseconds.zero?
    time = explode_ms(milliseconds)
    time.drop_while { |_, unit| unit.zero? }.first(num_units).to_h.map { |k, v| "#{v.to_i}#{k}" }.join(' ')
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

  private

  # explode_ms returns a hash with the components of the given duration separated out. The returned hash is guaranteed
  # to be ordered by component size descending (hours before minutes, etc.).
  def explode_ms(total_milliseconds)
    total_seconds = total_milliseconds / 1000
    total_minutes = total_seconds / 60
    total_hours   = total_minutes / 60

    {
      h:  total_hours,
      m:  total_minutes % 60,
      s:  total_seconds % 60,
      ms: total_milliseconds % 1000
    }
  end
end
