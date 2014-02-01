require 'htmlentities'

class RunsController < ApplicationController
  def create
    splits = params[:file]
    run = Run.create(nick: new_nick, user: nil)
    if splits.present?
      File.open(Rails.root.join('private', 'runs', run.nick), 'wb') do |file|
        file.write splits.read
      end
      respond_to do |format|
        format.html { redirect_to run_path run.nick }
        format.json { render text: run.nick }
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

    @run_record = Run.find_by nick: params[:nick]
    render :bad_url and return if @run_record.nil?

    @run_record.hits += 1 and @run_record.save
    @run = parse @run_record
    if @run.present?
      respond_to do |format|
        format.html { render :show }
        format.json { render @run_record }
      end
    else
      if @run_record.hits > 1 then render :cant_parse
      else @run_record.destroy and redirect_to cant_parse_path end
    end
  end
  def download
    @run_record = Run.find_by nick: params[:nick]
    render :bad_url and return if @run_record.nil?

    @run_record.hits += 1 and @run_record.save
    @run = parse @run_record
    if @run.present?
      file_extension = params[:format] == 'livesplit' ? '.lss' : params[:format]
      send_data(HTMLEntities.new.decode(render_to_string(params[:format], layout: false)), filename: @run_record.nick + file_extension, content_type: "text/html", layout: false)
    else
      if @run_record.hits > 1 then render :cant_parse
      else @run_record.destroy and redirect_to cant_parse_path end
    end
  end
  def download_original
    @run_record = Run.find_by nick: params[:nick]
    render :bad_url and return if @run_record.nil?

    @run_record.hits += 1 and @run_record.save
    
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
      break if parse(run).present?
    end
    session[:random] = true
    redirect_to run_path(run.nick)
  end

  def parse(run)
    splits = File.read Rails.root.join "private", "runs", run.nick

    begin
      [WsplitParser.new, TimesplittrackerParser.new, SplitterzParser.new, LivesplitParser.new].each do |p|
        result = p.parse(splits) and return result
      end
    rescue ArgumentError # comes from non UTF-8 files
      return nil
    end

    return nil
  end
  def new_nick
    loop do
      nick = SecureRandom.urlsafe_base64(3)
      return nick if Run.find_by(nick: nick).nil?
    end
  end
end
