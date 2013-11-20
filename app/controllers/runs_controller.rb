require 'wsplit_parser'

class RunsController < ApplicationController
  def create
    splits = params[:file]
    run = Run.create(nick: new_nick, user: nil)
    File.open(Rails.root.join('private', 'runs', run.nick), 'wb') do |file|
      file.write(splits.read)
    end
    render text: run.nick
  end
  def show
    @run_record = Run.find_by nick: params[:nick]
    @run_record.hits += 1
    @run_record.save
    splits = File.read Rails.root.join "private", "runs", @run_record.nick
    wsplit_data           = WsplitParser.new.parse splits
    timesplittracker_data = TimesplittrackerParser.new.parse splits
    if wsplit_data.present?
      @run = wsplit_data
      render :wsplit
    elsif timesplittracker_data.present?
      @run = timesplittracker_data
      render :timesplittracker
    else
      if @run_record.hits > 1
        # If the run has already been viewed (and thus successfully parsed in
        # the past), we don't want to delete it
        render "runs/cant_parse"
      else
        # If not, we do
        @run_record.destroy
        redirect_to cant_parse_path
      end
    end
  end
  def download
    run = Run.find_by nick: params[:nick]
    file = Rails.root.join "private", "runs", run.nick
    send_file file, type: "application/text"
  end

  def new_nick
    nick = SecureRandom.urlsafe_base64(4)
    while Run.find_by(nick: nick).present?
      nick = SecureRandom.urlsafe_base64(4)
    end
    nick
  end
end
