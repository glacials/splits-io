class Runs::SpeedrunDotComRunsController < Runs::ApplicationController
  before_action :set_run,          only: [:create]
  before_action :verify_ownership, only: [:create]
  before_action :verify_srdc_key,  only: [:create]

  def create
    run_json = {
      run: {
        category: @run.category.srdc.srdc_id,
        date:     params[:srdc_date],
        times:    {},
        # Convert '0' and '1' from the checkbox to boolean values
        emulated: !params[:srdc_emulator].to_i.zero?,
        comment:  params[:srdc_desc],
        splitsio: @run.id36
      }
    }

    run_json[:run][:region]   = params[:srdc_region]   if params[:srdc_region]
    run_json[:run][:platform] = params[:srdc_platform] if params[:srdc_platform]

    video = params[:srdc_video].presence || @run.video&.url
    run_json[:run][:video] = video if video.present?

    if @run.game.srdc.accepts_realtime? && @run.realtime_duration_ms.positive?
      run_json[:run][:times][:realtime] = @run.realtime_duration_ms / 1000
    end
    if @run.game.srdc.accepts_gametime? && @run.gametime_duration_ms.positive?
      run_json[:run][:times][:ingame] = @run.gametime_duration_ms / 1000
    end

    if params[:srdc_variables]
      run_json[:run][:variables] = {}
      params[:srdc_variables].each do |key, value|
        run_json[:run][:srdc_variables][key]         = {}
        run_json[:run][:srdc_variables][key][:type]  = 'pre-defined'
        run_json[:run][:srdc_variables][key][:value] = value
      end
    end

    # TODO: Save video if YT/Twtich and not present on Splits.io
    response = SpeedrunDotCom::Run.create(run_json, @run.user.srdc.api_key)
    if response['errors'].present?
      flash[:alert] = response['errors'].join('\n')
      redirect_to run_path(@run)
      return
    end

    @run.update!(srdc_id: response['data']['id'])
    flash[:notice] = "Run created on Speedrun.com! View it at #{SpeedrunDotCom::Run.url_from_id(response['data']['id'])}"
    redirect_to run_path(@run)
  end

  private

  def verify_ownership
    return if @run.belongs_to?(current_user)

    flash[:alert] = 'This run does not belong to you!'
    redirect_to run_path(@run)
  end

  def verify_srdc_key
    return if @run.user.srdc.api_key.present?

    flash[:alert] = 'You do no have a Speedrun.com API Key attached to your account!'
    redirect_to run_path(@run)
  end
end
