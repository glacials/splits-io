module ApplicationHelper
  def title(page_title)
    content_for(:title, page_title.to_s)
  end

  def order_runs(runs)
    col = params[:by].to_sym if [:created_at, :time, :user_id].include?(params[:by].try(:to_sym))
    dir = params[:order].to_sym if col && [:asc, :desc].include?(params[:order].try(:to_sym))
    runs.order(col || :created_at => dir || :desc)
  end
end
