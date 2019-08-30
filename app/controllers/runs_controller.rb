require 'uri'

class RunsController < ApplicationController
  before_action :set_run,         only: [:show, :destroy, :edit, :update]

  before_action :first_parse, only: [:show, :edit, :update], if: -> { @run.parsed_at.nil? }

  before_action :warn_about_deprecated_url, only: [:show], if: -> { request.path == "/#{@run.nick}" }
  before_action :attempt_to_claim,          only: [:show], if: -> { params[:claim_token].present? }

  before_action :maybe_update_followers, only: [:index]

  def show
    if params['reparse'] == '1'
      @run.parse_into_db
      redirect_to run_path(@run)
      return
    end

    @run.parse_into_db if @run.parsed_at.nil?
    @run.reload

    # Catch bad runs
    render :cant_parse, status: :internal_server_error if @run.timer.nil?
  end

  def index
  end

  def new
  end

  def edit
    if cannot?(:edit, @run)
      render :forbidden, status: :forbidden
      return
    end

    if params['reparse'] == '1'
      @run.parse_into_db
      redirect_to edit_run_path(@run), notice: 'Reparse complete. It might take a minute for your run to update.'
      return
    end
  end

  def update
    if cannot?(:edit, @run)
      render :forbidden, status: :forbidden
      return
    end

    unless params[@run.id36].respond_to?(:[])
      redirect_to edit_run_path(@run), alert: 'There was an error saving that data. Please try again.'
    end

    if params[@run.id36][:category]
      @run.update(category: Category.find(params[@run.id36][:category]))
      redirect_to edit_run_path(@run), notice: 'Game/category updated.'
      return
    end

    if params[@run.id36][:disown]
      @run.update(user: nil)
      redirect_to run_path(@run), notice: 'Run disowned.'
      return
    end

    if params[@run.id36][:srdc_url]
      srdc_id = SpeedrunDotCom::Run.id_from_url(params[@run.id36][:srdc_url])
      if !srdc_id
        redirect_params = {
          alert: 'Your Speedrun.com URL must have the format https://www.speedrun.com/tfoc/run/6yjoqgzd.'
        }
      elsif !@run.update(srdc_id: srdc_id)
        redirect_params = {alert: 'There was an error updating your Speedrun.com link. Please try again.'}
      else
        redirect_params = {notice: 'Link with Speedrun.com updated.'}
      end
      redirect_to edit_run_path(@run), redirect_params
      return
    end

    if params[@run.id36][:video_url]
      if @run.update(video_url: params[@run.id36][:video_url])
        redirect_back(fallback_location: edit_run_path(@run), notice: 'Video saved! 📹')
      else
        redirect_to edit_run_path(@run), alert: @run.errors.full_messages.join(' ')
      end
    end

    if params[@run.id36][:archived]
      if @run.update(archived: params[@run.id36][:archived])
        if params[@run.id36][:archived] == 'true'
          redirect_to edit_run_path(@run), notice: 'Run unlisted.'
        else
          redirect_to edit_run_path(@run), notice: 'Run listed.'
        end
      else
        redirect_to edit_run_path(@run), alert: @run.errors.full_messages.join(' ')
      end
    end

    if params[@run.id36][:default_timing]
      if @run.update(default_timing: params[@run.id36][:default_timing])
        if params[@run.id36][:default_timing] == 'real'
          redirect_to edit_run_path(@run), notice: 'Default timing changed to realtime.'
        else
          redirect_to edit_run_path(@run), notice: 'Default timing changed to gametime.'
        end
      else
        redirect_to edit_run_path(@run), alert: @run.errors.full_messages.join(' ')
      end
    end
  end

  def random
    redirect_to Run.random
  end

  def destroy
    if cannot?(:destroy, @run)
      render :forbidden, status: :forbidden
      return
    end

    if @run.destroy
      redirect_to root_path, notice: 'Run deleted.'
    else
      redirect_to root_path, alert: 'There was an error deleting your run. Please try again.'
    end
  end

  private

  def set_run
    @run = Run.find_by(id: params[:run].to_i(36)) || Run.find_by!(nick: params[:run])
    @run.parse_into_db unless @run.parsed?
    timing = params[:timing] || @run.default_timing

    gon.run = {
      id: @run.id36,

      splits:         @run.collapsed_segments(timing),
      timer:          @run.timer,
      video_url:      @run.video_url,
      default_timing: @run.default_timing
    }

    @compare_runs = Run.where(id: (params[:compare] || '').split(',').map { |r| r.to_i(36) })
    gon.compare_runs = @compare_runs.map { |run| {id: run.id36} }

    gon.run['user'] = if @run.user.nil?
                        nil
                      else
                        {id: @run.user.id, name: @run.user.name}
                      end

    gon.scale_to = @run.duration_ms(timing)
  rescue ActionController::UnknownFormat, ActiveRecord::RecordNotFound
    render :not_found, status: :not_found
  end

  def first_parse
    @run.parse_into_db
    return unless @run.parsed_at.nil?

    @run.destroy
    redirect_to cant_parse_path
  end

  def warn_about_deprecated_url
    redirect_to(
      run_path(@run),
      alert: "This run's permalink has changed. You have been redirected to the newer one. \
              <a href='#{why_permalinks_path}'>More info</a>.".html_safe
    )
  end

  def attempt_to_claim
    # Owned run
    if @run.user.present?
      redirect_to run_path(@run)
      return
    end

    # Unowned but unclaimable run
    if @run.claim_token.nil?
      redirect_to run_path(@run), alert: 'This run is not claimable, as it has been previously claimed then disowned.'
      return
    end

    # Unowned and claimable run, but bad claim token
    if @run.claim_token != params[:claim_token]
      redirect_to run_path(@run), alert: 'Could not claim this run with that token. Do you have your URLs mixed up?'
      return
    end

    # Unowned and claimable run with a good claim token, but user isn't logged in
    # Don't redirect here; JavaScript will save the claim token to local storage and do the redirect. This will give the
    # user UI to claim the run if they log in later (see app/javascript/run_claim.js).
    return if current_user.nil?

    # Unowned and claimable run with a good claim token and a logged-in user :)
    @run.update(user: current_user, claim_token: nil)
  end

  def maybe_update_followers
    return if current_user.nil? || current_user.twitch.nil?
    return if current_user.twitch.follows_synced_at > Time.now.utc - 1.day

    SyncUserFollowsJob.perform_later(current_user, current_user.twitch)
    current_user.twitch.update(follows_synced_at: Time.now.utc)
  end
end
