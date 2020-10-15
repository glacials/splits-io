require 'uri'

class RunsController < ApplicationController
  before_action :set_run, only: [:show, :destroy, :edit, :update]

  before_action :warn_about_deprecated_url, only: [:show], if: -> { request.path == "/#{@run.nick}" }
  before_action :attempt_to_claim,          only: [:show], if: -> { params[:claim_token].present? }

  before_action :maybe_update_followers, only: [:index]

  def show
    ParseRunJob.perform_later(@run) unless @run.parsed?
  end

  def index
    return if current_user.present?

    # Below code pretends we're viewing an example run, for the landing page.
    # gcb is a great example run in production, but fall back to anything.
    params[:id] = (Run.find_by(id: 'gcb'.to_i(36)) || Run.first)&.id36
    redirect_to(faq_path, alert: 'Cannot render frontpage due to an internal error.') if params[:id].nil?
    set_run
  end

  def edit
    if cannot?(:edit, @run)
      render :forbidden, status: :forbidden
      return
    end

    if params['reparse'] == '1'
      @run.update(parsed_at: nil) if @run.parsed?
      ParseRunJob.perform_later(@run)
      redirect_to @run, notice: 'Your parse is in progress. This page will refresh automatically.'
      return
    end
  end

  def update
    if cannot?(:edit, @run)
      render :forbidden, status: :forbidden
      return
    end

    if run_params[:category]
      @run.update(category: Category.find(run_params[:category]))
      redirect_to edit_run_path(@run), notice: 'Game/category updated.'
      return
    end

    if run_params[:disown]
      @run.update(user: nil)
      redirect_to @run, notice: 'Run disowned.'
      return
    end

    if run_params[:srdc_url]
      srdc_id = SpeedrunDotCom::Run.id_from_url(run_params[:srdc_url])

      if run_params[:srdc_url].present? && !srdc_id
        redirect_params = {
          alert: 'Your speedrun.com URL must have the format https://www.speedrun.com/tfoc/run/6yjoqgzd.',
        }
      elsif !@run.update(srdc_id: srdc_id)
        redirect_params = {alert: 'There was an error updating your speedrun.com link. Please try again.'}
      else
        redirect_params = {notice: 'Link with speedrun.com updated.'}
      end
      redirect_to edit_run_path(@run), redirect_params
      return
    end

    if run_params[:archived]
      if @run.update(archived: run_params[:archived])
        if run_params[:archived] == 'true'
          redirect_to edit_run_path(@run), notice: 'Run unlisted.'
        else
          redirect_to edit_run_path(@run), notice: 'Run listed.'
        end
      else
        redirect_to edit_run_path(@run), alert: @run.errors.full_messages.join(' ')
      end
    end

    if run_params[:default_timing]
      if @run.update(default_timing: run_params[:default_timing])
        if run_params[:default_timing] == 'real'
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
      redirect_back fallback_location: root_path, alert: 'There was an error deleting your run. Please try again.'
    end
  end

  private

  def set_run
    @run = Run.includes(segments: {icon_attachment: :blob}).find_by(id: params[:id].to_i(36)) ||
           Run.includes(segments: {icon_attachment: :blob}).find_by!(nick: params[:id])
    timing = params[:timing] || @run.default_timing
    unless [Run::REAL, Run::GAME].include?(timing)
      redirect_to request.path, alert: 'Timing can only be real or game.'
      return
    end

    gon.run = {
      id:             @run.id36,
      splits:         @run.collapsed_segments(timing),
      timer:          @run.timer,
      video_url:      @run.video&.url,
      default_timing: @run.default_timing,
    }

    @compare_runs = Run.where(id: (params[:compare] || '').split(',').map { |r| r.to_i(36) })
    gon.compare_runs = @compare_runs.map { |run| {id: run.id36} }

    gon.run['user'] = if @run.user.nil?
                        nil
                      else
                        {id: @run.user.id, name: @run.user.name}
                      end

    gon.scale_to = [@run.duration(timing).to_ms, *@compare_runs.map { |run| run.duration(timing).to_ms }].compact.max
  rescue ActionController::UnknownFormat, ActiveRecord::RecordNotFound
    render :not_found, status: :not_found
  end

  def warn_about_deprecated_url
    redirect_to(
      @run,
      alert: "This run's permalink has changed. You have been redirected to the newer one. \
              <a href='#{why_permalinks_path}'>More info</a>.".html_safe
    )
  end

  def attempt_to_claim
    # Owned run
    if @run.user.present?
      redirect_to @run
      return
    end

    # Unowned but unclaimable run
    if @run.claim_token.nil?
      redirect_to @run, alert: 'This run is not claimable, as it has been previously claimed then disowned.'
      return
    end

    # Unowned and claimable run, but bad claim token
    if @run.claim_token != params[:claim_token]
      redirect_to @run, alert: 'Could not claim this run with that token. Do you have your URLs mixed up?'
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
    return if (current_user&.twitch).nil?
    return if current_user.twitch.follows_synced_at > Time.now.utc - 1.day

    SyncUserFollowsJob.perform_later(current_user, current_user.twitch)
    current_user.twitch.update(follows_synced_at: Time.now.utc)
  end

  def run_params
    params.require(:run).permit(:reparse, :category, :disown, :srdc_url, :archived, :default_timing)
  end
end
