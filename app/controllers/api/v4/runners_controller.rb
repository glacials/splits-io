class Api::V4::RunnersController < Api::V4::ApplicationController
  before_action :set_runner, only: [:show]

  def index
    if params[:search].blank?
      render status: :bad_request, json: {status: :bad_request, message: 'You must supply a `search` term.'}
      return
    end
    @runners = User.search(params[:search])
    render json: UserBlueprint.render(@runners, view: :api_v4, root: :runners)
  end

  def show
    render json: UserBlueprint.render(@runner, view: :api_v4, root: :runner)
  end
end
