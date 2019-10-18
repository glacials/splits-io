class Api::V4::Runs::SplitsController < Api::V4::ApplicationController
  before_action :set_run
  before_action only: [:create] do
    doorkeeper_authorize! :upload_run
  end

  def create
    options = { root: :run }
    options[:historic] = true if params[:historic] == '1'
    options[:segment_groups] = true if params[:segment_groups] == '1'

    if @run.split(
      more:            params[:more] == '1',
      realtime_end_ms: split_params[:realtime_end_ms],
      gametime_end_ms: split_params[:gametime_end_ms],
    )
      render json: Api::V4::RunBlueprint.render(@run, options)
    else
      render status: :bad_request, json: {
        status: 400,
        message: @run.errors.full_messages.to_sentence,
      }
    end
  end

  private

  def split_params
    params.require(:split).permit(
      :realtime_end_ms,
      :gametime_end_ms,
    )
  end
end
