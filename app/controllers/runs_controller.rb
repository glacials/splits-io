require 'htmlentities'
require 'uri'

class RunsController < ApplicationController
  before_filter :set_run, only: [:show, :download, :disown, :delete]
  after_filter only: [:show, :upload, :download, :random, :disown, :delete] do |controller|
    StatsMix.track(controller.action_name, 1, meta: { game: @run.game.try(:name), user_signed_in: user_signed_in? })
  end

  def search
    if params[:term].present?
      redirect_to "/search/#{URI.escape(params[:term])}"
    end
  end

  def results
    @term = params[:term]
    @runs = (Game.search(@term).map(&:categories).flatten.map(&:runs).flatten | Category.search(@term).map(&:runs).flatten).sort_by(&:hits)
  end

  def show
    @random = session[:random] || false
    session[:random] = false

    render :bad_url if @run.try(:file).nil?

    @run.user = current_user if @run.hits == 0 && user_signed_in?
    @run.hits += 1
    @run.save
    if @run.parses
      respond_to do |format|
        format.html { render :show }
        format.json { render json: @run }
      end
    else
      if @run.hits > 1
        render :cant_parse
      else
        @run.destroy
        redirect_to(cant_parse_path)
      end
    end
  end

  def upload
    splits = params[:file]
    @run = Run.create
    @run.file = splits.read
    if @run.parses
      @run.user = current_user
      @run.image_url = params[:image_url]
      game = Game.find_by(name: @run.parsed.game) || Game.create(name: @run.parsed.game)
      @run.category = Category.find_by(game: game, name: @run.parsed.category) || game.categories.new(game: game, name: @run.parsed.category)
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
  end

  def download
    if @run.nil?
      render(:bad_url)
      return
    end

    @run.hits += 1
    @run.save
    if @run.present?
      file_extension = params[:program] == 'livesplit' ? 'lss' : params[:program]
      if params[:program].to_sym == @run.program # If the original program was requested, serve the original file
        send_data(HTMLEntities.new.decode(@run.file), filename: "#{@run.nick}.#{file_extension}", layout: false)
      else
        send_data(HTMLEntities.new.decode(render_to_string(params[:program], layout: false)), filename: "#{@run.nick}.#{file_extension}", layout: false)
      end
    else
      if @run.hits > 1
        render(:cant_parse)
      else
        @run.destroy
        redirect_to(cant_parse_path)
      end
    end
  end

  def random
    @run = Run.offset(rand(Run.count)).first
    if @run.nil?
      redirect_to root_path, alert: 'There are no runs yet!'
    else
      session[:random] = true
      redirect_to(run_path(@run.nick))
    end
  end

  def disown
    if @run.user.present? && current_user == @run.user
      @run.user = nil
      @run.save
      redirect_to(root_path)
    else
      redirect_to(run_path(@run.nick))
    end
  end

  def delete
    if @run.user.present? && current_user == @run.user
      @run.destroy
      redirect_to(root_path)
    else
      redirect_to(run_path(@run.nick))
    end
  end

  protected

  def set_run
    @run = Run.find_by(nick: params[:run])
  end

end
