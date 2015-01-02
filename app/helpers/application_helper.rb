module ApplicationHelper
  def title(page_title)
    content_for(:title, page_title.to_s)
  end

  def order_runs(runs)
    col = params[:by] if [:created_at, :time, :user_id].map(&:to_s).include?(params[:by])
    dir = params[:order].to_sym if col && [:asc, :desc].map(&:to_s).include?(params[:order])
    runs.order((col || :created_at) => (dir || :desc))
  end
end
