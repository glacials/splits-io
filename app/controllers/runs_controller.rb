require 'htmlentities'
require 'uri'

class RunsController < ApplicationController
  before_action :set_run, only: [:show, :download, :destroy, :compare, :edit, :update]
  before_action :set_comparison, only: :compare

  before_action :handle_first_visit, only: [:show, :edit, :update], unless: Proc.new { @run.visited? }
  before_action :warn_about_deprecated_url, only: [:show], if: Proc.new { request.path == "/#{@run.nick}" }
  before_action :reject_as_unparsable, only: [:show, :download], unless: Proc.new { @run.parses? }

  before_action :attempt_to_claim, only: [:show]
  before_action :verify_ownership, only: [:edit, :update, :destroy]

  def show
    @run.delay.refresh_from_file if rand < SplitsIO::Application.config.run_refresh_chance
  end

  def index
  end

  def new
  end

  def edit
  end

  def update
    if params[:run][:disown]
      @run.update_attributes(user: nil)
      redirect_to run_path(@run), notice: 'Run disowned.'
      return
    end

    if @run.update_attributes(video_url: params[:run][:video_url])
      redirect_to edit_run_path(@run), notice: 'Proof saved.'
    else
      redirect_to edit_run_path(@run), alert: @run.errors.full_messages.join(' ')
    end
  end

  def create
    run_file = RunFile.for_file(params.require(:file))
    @run = Run.new(run_file: run_file, user: current_user, image_url: params[:image_url])
    if @run.save
      redirect_to run_path(@run)
    else
      redirect_to :cant_parse
    end
  rescue ActiveRecord::StatementInvalid
    redirect_to :cant_parse
  end

  def download
    send_data(
      if params[:program] == @run.program.to_s
        @run.file
      else
        render_to_string(params[:program], layout: false)
      end,
      filename: "#{@run.to_param}.#{params[:program] == 'livesplit' ? 'lss' : params[:program]}",
      layout: false
    )
  end

  def random
    redirect_to run_path(Run.offset(rand(Run.unscoped.count)).first)
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
    @run = Run.find_by(id: params[:id].to_i(36)) || Run.find_by(nick: params[:id])
    if @run.blank?
      render :not_found, status: 404
      return false
    end
  rescue ActionController::UnknownFormat
    render status: 404, text: "404 Run not found"
  end

  def set_comparison
    return if params[:comparison_run].blank?
    @comparison_run = Run.find_by_id(params[:comparison_run].to_i(36)) || Run.find_by(nick: params[:comparison_run])
    if @run.blank? || @comparison_run.blank?
      render :not_found, status: 404
      return false
    end
  end

  def verify_ownership
    unless @run.belongs_to?(current_user)
      render :unauthorized, status: 401
      return false
    end
  end

  def mark_visited
    return if @run.visited?
    @run.visited = true
    @run.save
  end

  def warn_about_deprecated_url
    redirect_to run_path(@run), flash: {
      icon: 'warning-sign',
      alert: "This run's permalink has changed. You have been redirected to the newer one. \
              <a href='#{why_path}'>More info</a>.".html_safe
    }
    return false
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
      @run.update_attributes(user: current_user)
      redirect_to run_path(@run)
    end
  end

  def handle_first_visit
    if @run.parses?
      @run.update(visited: true, user: @run.user || current_user)
    else
      @run.destroy
      redirect_to cant_parse_path
    end
  end
end
