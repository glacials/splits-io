require 'htmlentities'

class RunsController < ApplicationController

  def create
    splits = params[:file]
    run = Run.new
    run.user = current_user
    run.image_url = params[:image_url]
    run.save
    if splits.present?
      File.open(Rails.root.join('private', 'runs', run.nick), 'wb') do |file|
        file.write splits.read
      end
      respond_to do |format|
        format.html { redirect_to run_path(run.nick) }
        format.json { render text: run_path(run.nick) }
      end
    else
      respond_to do |format|
        format.html { redirect_to upload_path, alert: "Didn't receive any uploaded file, try again." }
      end
    end
  end

  def show
    @random = session[:random] or false
    session[:random] = false

    @run = Run.find_by nick: params[:nick]
    render :bad_url and return if @run.nil?

    @run.user = current_user if @run.hits == 0 && user_signed_in?
    @run.hits += 1
    @run.save
    if @run.parse
      respond_to do |format|
        format.html { render :show }
        format.json { render @run }
      end
    else
      if @run.hits > 1 then render :cant_parse
      else @run.destroy and redirect_to(cant_parse_path) end
    end
  end

  def download
    @run = Run.find_by nick: params[:nick]
    if @run.nil?
      render(:bad_url) and return
    end

    @run.hits += 1 and @run.save
    if @run.present?
      file_extension = params[:format] == 'livesplit' ? 'lss' : params[:format]
      if params[:format] == @run.format.downcase # If the original format was requested, serve the original file
        send_data(HTMLEntities.new.decode(File.read("private/runs/#{@run.nick}")), filename: "#{@run.nick}.#{file_extension}", layout: false)
      else
        send_data(HTMLEntities.new.decode(render_to_string(params[:format], layout: false)), filename: "#{@run.nick}.#{file_extension}", layout: false)
      end
    else
      if @run.hits > 1 then render(:cant_parse)
      else @run.destroy and redirect_to(cant_parse_path) end
    end
  end

  def random
    # Find a random run. If we can't parse it, find another, and so on.
    run = nil
    if request.env["HTTP_REFERER"].present?
      # Don't use the run that we just came from (i.e. we're spam clicking random)
      last_run = URI.parse(URI.encode request.env["HTTP_REFERER"].strip).path
      last_run.slice! 0 # Remove initial '/'
    else
      last_run = nil
    end
    loop do
      run = Run.where.not(nick: last_run).sample(1).first
      if run.nil?
        redirect_to root_path, alert: 'There are no runs yet!' and return
      end
      break if run.parse.present?
    end
    session[:random] = true
    redirect_to run_path(run.nick)
  end

  def disown
    @run = Run.find_by(nick: params[:nick])

    if @run.user.present? && current_user == @run.user
      @run.user = nil
      @run.save and redirect_to(root_path)
    else
      redirect_to(run_path(@run.nick))
    end
  end

  def delete
    @run = Run.find_by(nick: params[:nick])

    if @run.user.present? && current_user == @run.user
      @run.destroy and redirect_to(root_path)
    else
      redirect_to(run_path(@run.nick))
    end
  end

end
