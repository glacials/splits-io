class Api::V4::Categories::RunnersController < Api::V4::ApplicationController
  before_action :set_category, only: [:index]

  def index
    render json: Api::V4::UserBlueprint.render(@category.users, root: :runners)
  end
end
