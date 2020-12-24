class Api::V4::FeedItemsController < Api::V4::ApplicationController
  before_action :set_user, only: %i[index]
  before_action :validate_user, only: %i[index]

  def index
    runs_by_twitch_follows = Run.includes(:game, :category, :user).where(
      users: { twitch: current_user.twitch.follows },
    ).where.not(
      games: { name: [nil, ""] },
    ).order("runs.created_at DESC").limit(6)

    render json: Api::V4::FeedItemBlueprint.render(
      runs_by_twitch_follows.map do |run|
        {
          type: :run,
          run: run,
        }
      end
    )
  end
end
