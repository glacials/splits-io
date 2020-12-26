class Api::V4::FeedItemsController < Api::V4::ApplicationController
  before_action :set_user, only: %i[index]
  before_action :set_feed_items
  before_action :validate_user, only: %i[index]

  def index
    render json: Api::V4::FeedItemBlueprint.render(@feed_items, root: :feed_items)
  end

  private

  def set_feed_items
    @feed_items = paginate(Run.includes(:game, :category, :user).where(
      users: { twitch: current_user.twitch.follows },
    ).where.not(
      games: { name: [nil, ""] },
    ).order("runs.created_at DESC").map { |run| { type: :run, run: run } })
  end
end
