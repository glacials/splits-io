class Api::V4::Users::Games::Categories::PbsController < Api::V4::ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_game, only: [:show]
  before_action :set_category, only: [:show]
  before_action :set_pb, only: [:show]

  def show
    render json: @pb, serializer: class.parent::RunWithSplitsSerializer
  end

  private

  def set_pb
    unless @pb = @user.pb_for(@category)
      render not_found(:run, :pb)
    end
  end
end
