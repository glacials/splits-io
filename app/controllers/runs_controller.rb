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
      @run = parse @run_record
      if @run.present?
        render @run.parser
      else
        if @run_record.hits > 1
          render :cant_parse
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
    # Find a random run. If we can't parse it, find another, and so on.
    run = nil
    loop do
      run = Run.all.sample(1).first
      break if parse(run).present?
    end
    redirect_to run_path run.nick
  end

  def parse(run)
    splits = File.read Rails.root.join "private", "runs", run.nick

    begin
      result = WsplitParser.new.parse splits
      if result.present?
        result.parser = :wsplit
        return result
      end

      result = TimesplittrackerParser.new.parse splits
      if result.present?
        result.parser = :timesplittracker
        return result
      end

      result = SplitterzParser.new.parse splits
      if result.present?
        result.parser = :splitterz
        return result
      end
    rescue ArgumentError # comes from non UTF-8 files
      return nil
    end

    return nil
  end
  def new_nick
    nick = SecureRandom.urlsafe_base64(3)
    while Run.find_by(nick: nick).present?
      nick = SecureRandom.urlsafe_base64(3)
    end
    nick
  end
end
