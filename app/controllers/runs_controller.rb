require 'htmlentities'
require 'uri'

class RunsController < ApplicationController
  before_action :set_run, only: [:show, :download, :disown, :delete]
  before_action :increment_hits, only: [:show, :download]

  def show
    @random = session[:random] || false
    session[:random] = false

    @run.user = current_user if @run.hits == 1 && user_signed_in?
    if @run.parses?
      respond_to do |format|
        format.html { render :show }
        format.json { render json: @run }
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
    splits = params[:file]
    @run = Run.create
    @run.file = splits.read
    if @run.parses?
      @run.user = current_user
      @run.image_url = params[:image_url]
      game = Game.find_by(name: @run.parse.game) || Game.create(name: @run.parse.game)
      @run.category = Category.find_by(game: game, name: @run.parse.category) || game.categories.new(name: @run.parse.category)
      @run.save
      respond_to do |format|
        format.html { redirect_to run_path(@run.nick) }
        format.json { render json: { url: request.protocol + request.host_with_port + run_path(@run.nick) } }
      end
    else
      @run.destroy
      respond_to do |format|
        format.html { redirect_to cant_parse_path }
        format.json { render json: { url: cant_parse_path } }
      end
    end
    params = {}
    if request.xhr?
      params['Client'] = 'drag and drop'
    elsif request.env['HTTP_USER_AGENT'] =~ /LiveSplit/i
      params['Client'] = request.env['HTTP_USER_AGENT']
    elsif request.referer =~ /\/upload/i
      params['Client'] = 'form'
    end
    mixpanel.track(current_user.try(:id), 'run uploaded', @run.tracking_info.merge(params))
  end

  def download
    if @run.present?
      file_extension = params[:program] == 'livesplit' ? 'lss' : params[:program]
      if params[:program].to_sym == @run.program # If the original program was requested, serve the original file
        send_data(HTMLEntities.new.decode(@run.file), filename: "#{@run.nick}.#{file_extension}", layout: false)
      else
        send_data(HTMLEntities.new.decode(render_to_string(params[:program], layout: false)), filename: "#{@run.nick}.#{file_extension}", layout: false)
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
      redirect_to(run_path(@run.nick))
    end
  end

  def disown
    if @run.belongs_to?(current_user)
      @run.disown
      @run.save
      redirect_to root_path
    else
      redirect_to run_path(@run.nick)
    end
  end

  def delete
    if @run.belongs_to?(current_user)
      @run.destroy
      redirect_to root_path
    else
      redirect_to run_path(@run.nick)
    end
  end

  protected

  def set_run
    @run = Run.find_by(nick: params[:run])
    if @run.try(:file).nil?
      render :bad_url
      return false
    end
  end

  def increment_hits
    @run.hit
    @run.save
  end
end
