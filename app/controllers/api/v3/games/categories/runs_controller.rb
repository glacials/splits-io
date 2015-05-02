class Api::V3::Games::Categories::RunsController < Api::V3::ApplicationController
  before_action :set_game, only: [:index]
  before_action :set_category, only: [:index]
  before_action :set_runs, only: [:index]

  def index
    paginate json: @runs, each_serializer: Api::V3::RunSerializer
  end

  def create
    # TODO: Tokens, not cookies
    run_file = RunFile.for_file(params.require(:file))
    @record = Run.new(run_file: run_file, user: current_user, image_url: params[:image_url]).tap do |run|
      # TODO: Move this error handling into a before_action or a rescue
      unless run.parses?
        render status: 400, json: {
          status: 400,
          message: "Can't parse that file. We support WSplit 1.4.x, Nitrofski's WSplit 1.5.x fork, Time Split Tracker, SplitterZ, Urn and LiveSplit >= 1.2."
        }
        return
      end
      run.save
    end
    head 201, location: api_v3_run_url(@record)
  rescue ActionController::ParameterMissing
    render status: 400, json: {
      status: 400,
      message: "No run file received. Make sure you're including a 'file' parameter in your request."
    }
  end

  private

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

  def set_runs
    @runs = @category.runs.includes(:game, :category, :user)
  end
end
