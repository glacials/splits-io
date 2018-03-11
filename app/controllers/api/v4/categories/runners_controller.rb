class Api::V4::Categories::RunnersController < Api::V4::ApplicationController
  before_action :set_category, only: [:index]

  def index
    render json: @category.users, each_serializer: Api::V4::RunnerSerializer, root: 'runners'
  end
end
