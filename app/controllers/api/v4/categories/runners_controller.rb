class Api::V4::Categories::RunnersController < Api::V4::ApplicationController
  before_action :set_category, only: [:index]

  def index
    render json: UserBlueprint.render(@category.users, view: :api_v4, root: :runners)
  end
end
