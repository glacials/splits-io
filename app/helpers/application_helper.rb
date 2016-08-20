module ApplicationHelper
  def title(page_title)
    content_for(:title, page_title.to_s)
  end

  def order_runs(runs)
    col = params[:by] if ['created_at', 'time', 'user_id', 'name'].include?(params[:by])
    dir = params[:order].to_sym if col && ['asc', 'desc'].include?(params[:order])
    runs.order((col || 'created_at') => (dir || 'desc'))
  end

  def on_page
    {
      index: request.path == root_path || request.path == new_subscription_path,
      upload: request.path == new_run_path,
      games: request.path.match(games_path),
      rivalries: current_user.present? && request.path == user_rivalries_path(current_user),
      faq: request.path == faq_path,
      profile: logged_in? && [user_path(current_user), tools_path].include?(request.path)
    }
  end
end
