require 'htmlentities'
require 'uri'

require 'speedrundotcom'

class RunsController < ApplicationController
  before_action :set_run,        only: [:show, :download, :destroy, :compare, :edit, :update]
  before_action :set_comparison, only: [:compare]

  before_action :first_parse, only: [:show, :edit, :update, :download], if: -> { @run.parsed_at.nil? }

  before_action :warn_about_deprecated_url, only: [:show], if: -> { request.path == "/#{@run.nick}" }
  before_action :attempt_to_claim,          only: [:show], if: -> { params[:claim_token].present? }

  def show
    if params['reparse'] == '1'
      @run.parse_into_activerecord
      redirect_to run_path(@run)
      return
    end

    if @run.parsed_at.nil?
      @run.parse_into_activerecord
    end

    # Catch bad runs
    if @run.timer.nil?
      render :cant_parse, status: 500
    end
  end

  def index
  end

  def new
  end

  def edit
    if cannot?(:edit, @run)
      render :forbidden, status: 403
      return
    end

    if params['reparse'] == '1'
      @run.parse_into_activerecord
      redirect_to edit_run_path(@run), notice: 'Reparse complete. It might take a minute for your run to update.'
      return
    end

  end

  def update
    if cannot?(:edit, @run)
      render :forbidden, status: 403
      return
    end

    unless params[@run.id36].respond_to?(:[])
      redirect_to edit_run_path(@run), alert: "There was an error saving that data. Please try again."
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
        redirect_params = {alert: 'Your speedrun.com URL must have the format http://www.speedrun.com/run/6yjoqgzd.'}
      else
        if !@run.update(srdc_id: srdc_id)
          redirect_params = {alert: "There was an error updating your SRDC link. Please try again."}
        else
          redirect_params = {notice: "Link with Speedrun.com updated."}
        end
      end
      redirect_to edit_run_path(@run), redirect_params
      return
    end

    if params[@run.id36][:video_url]
      if @run.update(video_url: params[@run.id36][:video_url])
        redirect_to edit_run_path(@run), notice: 'Proof saved.'
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
  end

  def download
    # Enable CORS for this endpoint so clients can download files; this should be an API endpoint but I'm not sure how I
    # want the timer-specific views to belong to both an API namespace and a user namespace
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    timer = Run.program(params[:timer])
    if timer.nil?
      redirect_to run_path(@run), alert: 'Unrecognized timer.'
      return
    end

    begin
      s3_file = $s3_bucket.object("splits/#{@run.s3_filename}")

      if timer == Run.program(@run.timer) && s3_file.exists?
        redirect_to s3_file.presigned_url(:get,
          response_content_disposition: "attachment; filename=\"#{@run.filename}\""
        )
        return
      end
    rescue Aws::S3::Errors::Forbidden
    end

    send_data(
      if timer == Run.program(@run.timer)
        @run.file
      else
        render_to_string(params[:timer], layout: false)
      end,
      filename: "#{@run.filename(timer: timer)}",
      layout: false
    )
  end

  def random
    redirect_to Run.offset(rand(Run.count)).first
  end

  def destroy
    if cannot?(:destroy, @run)
      render :forbidden, status: 403
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
    @run.parse_into_activerecord unless @run.parsed?

    gon.run = {id: @run.id36, splits: @run.collapsed_segments}
    gon.scale_to = @run.duration_milliseconds
  rescue ActionController::UnknownFormat, ActiveRecord::RecordNotFound
    render :not_found, status: 404
  end

  def set_comparison
    return if params[:comparison_run].blank?
    @comparison_run = Run.find_by(id: params[:comparison_run].to_i(36)) || Run.find_by!(nick: params[:comparison_run])
    gon.comparison_run = {
      id: @comparison_run.id36,
      splits: @comparison_run.collapsed_segments
    }
    gon.scale_to = [@run.duration_milliseconds, @comparison_run.duration_milliseconds].max
  rescue ActiveRecord::RecordNotFound
    render :not_found, status: 404
  end

  def first_parse
    @run.parse_into_activerecord

    if @run.parsed_at.nil?
      @run.destroy
      redirect_to cant_parse_path
      return
    end
  end

  def warn_about_deprecated_url
    redirect_to(
      run_path(@run),
      alert: "This run's permalink has changed. You have been redirected to the newer one. \
              <a href='#{why_permalinks_path}'>More info</a>.".html_safe
    )
  end

  def attempt_to_claim
    if @run.user == nil && @run.claim_token.present? && @run.claim_token == params[:claim_token]
      @run.update(
        user: current_user,
        claim_token: nil
      )
    end

    redirect_to run_path(@run)
  end
end
