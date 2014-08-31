require 'htmlentities'
require 'uri'

class RunsController < ApplicationController
  before_action :set_run, only: [:show, :download, :disown, :delete, :compare]
  before_action :set_comparison, only: :compare
  before_action :increment_hits, only: [:show, :download]

  def show
    if request.fullpath != "/#{@run.id.to_s(36)}"
      mixpanel.track(current_user.try(:id), 'received an alert', {type: 'Permalink change', level: 'Warning'})
      redirect_to @run, alert: "This run's permalink has changed. You have been redirected to the newer one. \
                                <a href='#{why_path}'>More info</a>.".html_safe
      return
    end

    gon.run = {tracking_info: @run.tracking_info.except('Parses?', 'Screenshot?')}
    @random = session[:random] || false
    session[:random] = false

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
        render :cant_parse
      end
    end
  end

  def upload
    @run = Run.new
    @run.file = params[:file].read
    if @run.parses?
      @run.user = current_user
      @run.image_url = params[:image_url]
      game = Game.find_by(name: @run.parse[:game]) || Game.create(name: @run.parse[:game])
      @run.category = Category.find_by(game: game, name: @run.parse[:category]) || game.categories.new(name: @run.parse[:category])
      @run.save
      respond_to do |format|
        format.html { redirect_to run_path(@run), notice: "↑ That's your permalink!"}
        format.json { render json: { url: request.protocol + request.host_with_port + run_path(@run) } }
      end
    else
      @run.destroy
      respond_to do |format|
        format.html { redirect_to cant_parse_path }
        format.json { render json: { url: request.protocol + request.host_with_port + cant_parse_path } }
      end
    end
    tracking_params = {}
    if request.xhr?
      tracking_params['Client'] = 'drag and drop'
    elsif request.env['HTTP_USER_AGENT'] =~ /LiveSplit/i
      tracking_params['Client'] = request.env['HTTP_USER_AGENT']
    elsif request.referer =~ /\/upload/i
      tracking_params['Client'] = 'form'
    end
    mixpanel.track(current_user.try(:id), 'uploaded a run', @run.tracking_info.merge(tracking_params))
  end

  def download
    if @run.present?
      file_extension = params[:program] == 'livesplit' ? 'lss' : params[:program]
      if params[:program].to_sym == @run.program # If the original program was requested, serve the original file
        send_data(HTMLEntities.new.decode(@run.file), filename: "#{@run.to_param}.#{file_extension}", layout: false)
      else
        send_data(HTMLEntities.new.decode(render_to_string(params[:program], layout: false)), filename: "#{@run.to_param}.#{file_extension}", layout: false)
      end
    else
      if @run.new?
        @run.destroy
        redirect_to cant_parse_path
      else
        render :cant_parse
      end
    end
  end

  def random
    if Run.count == 0
      redirect_to root_path, alert: 'There are no runs yet!'
    else
      session[:random] = true
      @run = Run.offset(rand(Run.count)).first
      respond_to do |format|
        format.html { redirect_to(run_path(@run)) }
        format.json { render json: {redirect: run_path(@run)} }
      end
    end
  end

  def disown
    if @run.belongs_to?(current_user)
      @run.disown
      @run.save
      redirect_to :back
    else
      redirect_to run_path(@run)
    end
  end

  def delete
    if @run.belongs_to?(current_user)
      @run.destroy
      redirect_to root_path
    else
      redirect_to run_path(@run)
    end
  end

  protected

  def set_run
    @run = Run.find_by_id(params[:run].to_i(36)) || Run.find_by(nick: params[:run])
    if @run.try(:file).nil?
      render :bad_url
      return false
    end
  end

  def set_comparison
    return if params[:comparison_run].blank?
    @comparison_run = Run.find params[:comparison_run].to_i(36)
    if @comparison_run.try(:file).nil?
      render :bad_url
      return false
    end
  end

  def increment_hits
    @run.hit
    @run.save
  end
end
