class Runs::SpeedrunDotComRunsController < Runs::ApplicationController
  before_action :set_run,           only: [:create]
  before_action :verify_ownership,  only: [:create]
  before_action :verify_srdc_key,   only: [:create]
  before_action :verify_subscribed, only: [:create]

  def create
    run_json = {
      run: {
        category: @run.category.srdc.srdc_id,
        date:     params[:srdc_date],
        times:    {},
        splitsio: @run.id36
      }
    }

    # Convert '0' and '1' from the checkbox to boolean values
    run_json[:run][:emulated] = !params[:srdc_emulator].to_i.zero? if params[:srdc_emulator]

    run_json[:run][:comment] =  params[:srdc_desc] if params[:srdc_desc]
    run_json[:run][:region]   = params[:srdc_region]   if params[:srdc_region]
    run_json[:run][:platform] = params[:srdc_platform] if params[:srdc_platform]

    # Save video first, so we don't make the user keep pasting it back in if the submit attempt fails
    video = @run.create_video(url: params[:srdc_video]) if @run.video.nil? && params[:srdc_video].present?
    video_url = video&.url || @run.video&.url || params[:srdc_video]
    run_json[:run][:video] = video_url

    if @run.game.srdc.accepts_realtime? && @run.realtime_duration_ms.positive?
      run_json[:run][:times][:realtime] = @run.realtime_duration_ms / 1000
    end
    if @run.game.srdc.accepts_gametime? && @run.gametime_duration_ms.positive?
      run_json[:run][:times][:ingame] = @run.gametime_duration_ms / 1000
    end

    if params[:srdc_variables]
      run_json[:run][:variables] = {}
      params[:srdc_variables].each do |key, value|
        run_json[:run][:variables][key]         = {}
        run_json[:run][:variables][key][:type]  = 'pre-defined'
        run_json[:run][:variables][key][:value] = value
      end
    end

    response = SpeedrunDotCom::Run.create(run_json, @run.user.srdc.api_key)
    if response['errors'].present?
      flash[:alert] = response['errors'].join('\n')
      redirect_to run_path(@run)
      return
    end

    @run.update!(srdc_id: response['data']['id'])
    flash[:notice] = "Run submitted to Speedrun.com! View it at #{SpeedrunDotCom::Run.url_from_id(response['data']['id'])}"
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

  def verify_subscribed
    return if current_user.has_srdc_submit?

    flash[:alert] = 'You must be subscribed to Splits.io Gold to automatically submit to Speedrun.com.'
    redirect_to subscriptions_path(@run)
  end
end
