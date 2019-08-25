class Api::V4::RunnersController < Api::V4::ApplicationController
  before_action :set_runner, only: %i[show]
  before_action :set_user, only: %i[me]

  def index
    if params[:search].blank?
      render status: :bad_request, json: {status: 400, message: 'You must supply a `search` term.'}
      return
    end
    @runners = User.search(params[:search])
    render json: Api::V4::UserBlueprint.render(@runners, root: :runners)
  end

  def show
    render json: Api::V4::UserBlueprint.render(@runner, root: :runner)
  end

  def me
    if current_user.nil?
      head :unauthorized
      return
    end

    render json: Api::V4::UserBlueprint.render(current_user, root: :runner)
  end
end
