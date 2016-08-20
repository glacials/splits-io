require 'htmlentities'
require 'uri'

require 'speedrundotcom'

class RunsController < ApplicationController
  before_action :set_run, only: [:show, :download, :destroy, :compare, :edit, :update]
  before_action :set_comparison, only: :compare

  before_action :handle_first_visit, only: [:show, :edit, :update], unless: Proc.new { @run.visited? }
  before_action :warn_about_deprecated_url, only: [:show], if: Proc.new { request.path == "/#{@run.nick}" }
  before_action :reject_as_unparsable, only: [:show, :download], unless: Proc.new { @run.parses? }

  before_action :attempt_to_claim, only: [:show]
  before_action :verify_ownership, only: [:edit, :update, :destroy]

  def show
  end

  def index
  end

  def new
  end

  def edit
  end

  def update
    unless params[:run].respond_to?(:[])
      redirect_to edit_run_path(@run), alert: "There was an error saving that data. Please try again."
    end

    if params[:run][:category]
      @run.update(category: Category.find(params[:run][:category]))
      redirect_to edit_run_path(@run), notice: 'Game/category updated.'
      return
    end

    if params[:run][:disown]
      @run.update(user: nil)
      redirect_to run_path(@run), notice: 'Run disowned.'
      return
    end

    if params[:run][:srdc_url]
      srdc_id = SpeedrunDotCom::Run.id_from_url(params[:run][:srdc_url])
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

    if params[:run][:video_url]
      if @run.update(video_url: params[:run][:video_url])
        redirect_to edit_run_path(@run), notice: 'Proof saved.'
      else
        redirect_to edit_run_path(@run), alert: @run.errors.full_messages.join(' ')
      end
    end
  end

  def download
    program = Run.program(params[:program])
    if program.nil?
      redirect_to run_path(@run), alert: 'Unrecognized program.'
      return
    end

    begin
      s3_file = $s3_bucket.object("splits/#{@run.id36}")

      if program == Run.program(@run.program) && s3_file.exists?
        redirect_to s3_file.presigned_url(:get,
          response_content_disposition: "attachment; filename=\"#{@run.filename}\""
        )
        return
      end
    rescue Aws::S3::Errors::Forbidden
    end

    send_data(
      if program == Run.program(@run.program)
        @run.original_file
      else
        render_to_string(params[:program], layout: false)
      end,
      filename: "#{@run.filename(program: program)}",
      layout: false
    )
  end

  def random
    redirect_to Run.find_by(run_file: RunFile.random)
  end

  def destroy
    if @run.destroy
      redirect_to root_path, notice: 'Run deleted.'
    else
      redirect_to root_path, alert: 'There was an error deleting your run. Please try again.'
    end
  end

  private

  def set_run
    @run = Run.find_by(id: params[:id].to_i(36)) || Run.find_by!(nick: params[:id])
    gon.run = {id: @run.id, splits: @run.collapsed_splits}
    gon.scale_to = @run.time
  rescue ActionController::UnknownFormat, ActiveRecord::RecordNotFound
    render :not_found, status: 404
  end

  def set_comparison
    return if params[:comparison_run].blank?
    @comparison_run = Run.find_by(id: params[:comparison_run].to_i(36)) || Run.find_by!(nick: params[:comparison_run])
    gon.comparison_run = {id: @comparison_run.id, splits: @comparison_run.collapsed_splits}
    gon.scale_to = [@run.time, @comparison_run.time].max
  rescue ActiveRecord::RecordNotFound
    render :not_found, status: 404
  end

  def verify_ownership
    unless @run.belongs_to?(current_user)
      render :unauthorized, status: 401
    end
  end

  def warn_about_deprecated_url
    redirect_to run_path(@run), flash: {
      icon: 'warning-sign',
      alert: "This run's permalink has changed. You have been redirected to the newer one. \
              <a href='#{why_path}'>More info</a>.".html_safe
    }
  end

  def reject_as_unparsable
    if @run.visited?
      render :cant_parse, status: 500
    else
      @run.destroy
      redirect_to cant_parse_path
    end
  end

  def attempt_to_claim
    if @run.user == nil && @run.claim_token.present? && @run.claim_token == params[:claim_token]
      @run.update(user: current_user)
      redirect_to run_path(@run)
    end
  end

  def handle_first_visit
    if @run.parses?
      @run.update(visited: true)
    else
      @run.destroy
      redirect_to cant_parse_path
    end
  end
end
