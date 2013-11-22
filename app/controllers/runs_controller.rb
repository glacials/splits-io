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
    if @run_record.nil?
      render :bad_url
    else
      @run_record.hits += 1
      @run_record.save
      splits = File.read Rails.root.join "private", "runs", @run_record.nick
      begin
        wsplit_data           =           WsplitParser.new.parse splits
        timesplittracker_data = TimesplittrackerParser.new.parse splits
        splitterz_data        =        SplitterzParser.new.parse splits
        if wsplit_data.present?
          @run = wsplit_data
          render :wsplit
        elsif timesplittracker_data.present?
          @run = timesplittracker_data
          render :timesplittracker
        elsif splitterz_data.present?
          @run = splitterz_data
          render :splitterz
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
      rescue
        if @run_record.hits > 1
          render "runs/cant_parse"
        else
          @run_record.destroy
          redirect_to cant_parse_path
        end
      end
    end
  end
  def download
    run = Run.find_by nick: params[:nick]
    file = Rails.root.join "private", "runs", run.nick
    send_file file, type: "application/text"
  end
  def random
    redirect_to run_path Run.order("RANDOM()").first.nick
  end

  def new_nick
    nick = SecureRandom.urlsafe_base64(3)
    while Run.find_by(nick: nick).present?
      nick = SecureRandom.urlsafe_base64(3)
    end
    nick
  end
end
