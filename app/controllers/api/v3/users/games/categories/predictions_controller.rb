class Api::V3::Users::Games::Categories::PredictionsController < Api::V3::ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_game, only: [:show]
  before_action :set_category, only: [:show]
  before_action :set_prediction, only: [:show]

  def show
    most_recent_run = @user.runs.where(category: @category).order(created_at: :desc).last

    @prediction.merge!(
      id: nil,
      path: nil,
      name: most_recent_run.to_s,
      program: most_recent_run.program,
      image_url: nil,
      created_at: Time.now,
      updated_at: Time.now,
      user: Api::V3::UserSerializer.new(@user, root: false),
      game: Api::V3::GameSerializer.new(@game, root: false),
      category: Api::V3::CategorySerializer.new(@category, root: false),
      time: 0
    )
    @prediction[:splits] = most_recent_run.splits.map do |segment|
      {
        best: segment.shortest_duration_ms(Run::REAL),
        finish_time: @prediction[:time] += (segment.histories.map(&:realtime_duration_ms) + [segment.duration_ms(Run::REAL)]).reject { |duration| duration == 0 }.smma.to_f / 1000,
        duration: (segment.histories.map(&:realtime_duration_ms) + [segment.duration_ms(Run::REAL)]).reject { |duration| duration == 0 }.smma.to_f / 1000,
        gold?: false,
        skipped?: rand(0.99) < segment.histories.map(&:realtime_duration_ms).map { |time| time.nil? ? 1 : 0 }.smma
      }
    end
    render json: {prediction: @prediction}
  rescue MovingAverage::Errors::InvalidTailError
    render status: 404, json: {status: 404, message: "Not enough data on #{@user.name} to make a prediction."}
  end

  private

  def set_user
    @user = User.find_by(name: params[:user_id]) || User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {status: 404, message: "User with name or id '#{params[:user_id]}' not found."}
  end

  def set_game
    @game = Game.find_by(shortname: params[:game_id]) || Game.find(params[:game_id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {status: 404, message: "Game with shortname or id '#{params[:game_id]}' not found."}
  end

  def set_category
    @category = @game.categories.find(params[:category_id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {status: 404, message: "Category with id '#{params[:category_id]}' not found for game '#{params[:game_id]}'."}
  end

  def set_prediction
    unless @user.runs?(@category)
      render status: 404, json: {status: 404, message: "User with name or id '#{params[:user_id]}' doesn't run category '#{params[:category_id]}' for game '#{params[:game_id]}'."}
    end
    @prediction = {}
  end
end
