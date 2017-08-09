module ApplicationHelper
  def title(page_title)
    content_for(:title, page_title.to_s)
  end

  def order_runs(runs)
    col = case params[:by]
          when 'created_at'
            'created_at'
          when 'time'
            'realtime_duration_ms'
          when 'user_id'
            'user_id'
          end

    dir = params[:order].to_sym if col && ['asc', 'desc'].include?(params[:order])
    runs.order((col || 'created_at') => (dir || 'desc'))
  end

  def on_page
    {
      index: request.path == root_path,
      upload: request.path == new_run_path,
      games: request.path.match(games_path),
      rivalries: current_user.present? && request.path == rivalries_path,
      faq: request.path == faq_path,
      profile: logged_in? && [user_path(current_user), tools_path].include?(request.path),
			why_darkmode: request.path == why_darkmode_path
    }
  end
end
