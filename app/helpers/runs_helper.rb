module RunsHelper
  def table_locals(table_type, options = {})
    case table_type
    when :my_pbs
      {
        type: :current_user,
        source: current_user,
        runs: current_user.pbs,
        cols: [:time, :name, :uploaded, :owner_controls],
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
        runs: options[:game].runs,
        cols: [:runner, :time, :name, :uploaded]
      }.merge(sorting_info)
    when :category
      {
        type: :category,
        source: options[:category],
        runs: options[:category].runs,
        cols: [:runner, :time, :name, :uploaded]
      }.merge(sorting_info)
    else
      raise Error
    end
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
