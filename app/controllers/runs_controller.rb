require 'htmlentities'
require 'uri'

class RunsController < ApplicationController
  before_action :set_run, only: [:show, :download, :disown, :delete, :compare]
  before_action :set_comparison, only: :compare
  before_action :verify_ownership, only: [:disown, :delete]
  before_action :increment_hits, only: [:show, :download]

  def show
    if request.fullpath != "/#{@run.id.to_s(36)}"
      @mixpanel.track(current_user.try(:id), 'received an alert', type: 'Permalink change', level: 'Warning')
      redirect_to @run, flash: {
        icon: 'warning-sign',
        alert: "This run's permalink has changed. You have been redirected to the newer one. \
                <a href='#{why_path}'>More info</a>.".html_safe
      }
      return
    end

    @run.user = current_user if @run.hits == 1 && user_signed_in?
    if @run.parses?
      respond_to do |format|
        format.html { render :show }
        format.json { render json: @run.to_json }
      end
    else
      if @run.new?
        @run.destroy
        redirect_to cant_parse_path
      else
        respond_to do |format|
          format.json { render status: 400, json: {message: 'Unable to parse that file.'} }
          format.html { render :cant_parse, status: 400 }
        end
      end
    end
  end

  def upload
    @run = Run.new(file: params[:file].read, user: current_user, image_url: params[:image_url])
    if @run.parses?
      game = Game.where(name: @run.parse[:game]).first_or_create
      @run.category = game.categories.where(name: @run.parse[:category]).first_or_create
      @run.save
      respond_to do |format|
        format.json { render json: {url: request.protocol + request.host_with_port + run_path(@run)} }
        format.html { redirect_to run_path(@run) }
      end
    else
      @run.destroy
      respond_to do |format|
        format.json { render json: {url: request.protocol + request.host_with_port + cant_parse_path} }
        format.html { redirect_to cant_parse_path }
      end
    end
    tracking_properties = {}
    if request.xhr?
      tracking_properties['Client'] = 'JavaScript'
    elsif request.env['HTTP_USER_AGENT'] =~ /LiveSplit/i
      tracking_properties['Client'] = request.env['HTTP_USER_AGENT']
    elsif request.referer =~ /\/upload/i
      tracking_properties['Client'] = 'form'
    end
    @mixpanel.track(current_user.try(:id), 'uploaded a run', @run.to_tracking_properties.merge(tracking_properties))
  end

  def download
    file_extension = params[:program] == 'livesplit' ? 'lss' : params[:program]
    if params[:program].to_sym == @run.program # If the original program was requested, serve the original file
      send_data(HTMLEntities.new.decode(@run.file),
                filename: "#{@run.to_param}.#{file_extension}",
                layout: false)
    else
      send_data(HTMLEntities.new.decode(render_to_string(params[:program], layout: false)),
                filename: "#{@run.to_param}.#{file_extension}",
                layout: false)
    end
  end

  def random
    if Run.count == 0
      respond_to do |format|
        format.json { render status: 503, json: {message: 'No runs exist yet!'} }
        format.html { redirect_to root_path, flash: {icon: 'exclamation-sign', alert: 'No runs exist yet!'} }
      end
    else
      @run = Run.offset(rand(Run.count)).first
      respond_to do |format|
        format.html { redirect_to run_path(@run) }
        format.json { render json: @run }
      end
    end
  end

  def disown
    @run.user = nil
    @run.save
    respond_to do |format|
      format.json { head 200 }
      format.html { redirect_to :back }
    end
  end

  def delete
    @run.destroy
    respond_to do |format|
      format.json { head 200 }
      format.html { redirect_to :back, notice: 'Run deleted!' }
    end
  end

  private

  def set_run
    @run = Run.find_by(id: params[:run].to_i(36)) || Run.find_by(nick: params[:run])
    if @run.blank?
      respond_to do |format|
        format.json { render status: 404, json: {status: 404, error: "Run not found"} }
        format.html { render :not_found, status: 404 }
      end
      return false
    end
    gon.run = @run.as_json(methods: [:to_tracking_properties])
  rescue ActionController::UnknownFormat
    render status: 404, text: "404 Run not found"
  end

  def set_comparison
    return if params[:comparison_run].blank?
    @comparison_run = Run.find_by_id(params[:comparison_run].to_i(36)) || Run.find_by(nick: params[:comparison_run])
    if @run.blank? || @comparison_run.blank?
      respond_to do |format|
        format.json { head 404 }
        format.html { render :not_found, status: 404 }
      end
      return false
    end
  end

  def verify_ownership
    unless @run.belongs_to?(current_user)
      respond_to do |format|
        format.json { render status: 401, json: {status: 401, error: "Unauthorized"} }
        format.html { render :unauthorized, status: 401 }
      end
      return false
    end
  end

  def increment_hits
    @run.hits += 1
    @run.save
  end
end
