module RunsHelper

  TIMELINE_COLORS = [:blue, :purple, :green, :yellow, :red, :orange]

  def difference(run_a, run_b)
    if run_a.nil? || run_b.nil?
      return 0
    end

    run_a.time - run_b.time
  end

  def sob_difference(run_a, run_b)
    if run_a.nil? || run_b.nil?
      return 0
    end

    run_a.sum_of_best - run_b.sum_of_best
  end

  def difference_color(time)
    if time == 0
      :gray
    elsif time > 0
      :red
    else
      :green
    end
  end

  def table_locals(table_type, options = {})
    case table_type
    when :my_pbs
      {
        type: :current_user,
        source: current_user,
        runs: current_user.pbs,
        cols: [:time, :name, :uploaded, :owner_controls, :rival],
        description: "my personal bests"
      }.merge(sorting_info)
    when :pbs
      {
        type: :user,
        source: options[:user],
        runs: options[:user].pbs,
        cols: [:time, :name, :uploaded],
        description: "personal bests"
      }.merge(sorting_info)
    when :game
      {
        type: :game,
        source: options[:game],
        runs: options[:game].runs.nonempty,
        cols: [:runner, :time, :name, :uploaded]
      }.merge(sorting_info)
    when :category
      {
        type: :category,
        source: options[:category],
        runs: options[:category].runs.nonempty,
        cols: [:runner, :time, :name, :uploaded]
      }.merge(sorting_info)
    else
      raise Error
    end
  end

  def next_timeline_color(timeline_id)
    if @next_index.blank?
      @next_index = {}
    end

    if @next_index[timeline_id].blank?
      @next_index[timeline_id] = 0
    else
      @next_index[timeline_id] = (@next_index[timeline_id] + 1) % TIMELINE_COLORS.length
    end

    TIMELINE_COLORS[@next_index[timeline_id]]
  end

  private

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
