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
        format.html { redirect_to fallback_upload_path, alert: "Didn't receive any uploaded file, try again." }
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
      render :cant_parse if @run_record.hits > 1
      @run_record.destroy and redirect_to cant_parse_path if @run_record.hits <= 1
    end
  end
  def download
    @run_record = Run.find_by nick: params[:nick]
    if @run_record.nil?
      render :bad_url
    else
      @run_record.hits += 1
      @run_record.save
      @run = parse @run_record
      if @run.present?
        send_data(render_to_string(params[:format], layout: false), filename: @run_record.nick + "." + params[:format], content_type: "text/html", layout: false)
      else
        if @run_record.hits > 1
          render :cant_parse
        else
          @run_record.destroy
          redirect_to cant_parse_path
        end
      end
    end
    #file = Rails.root.join "private", "runs", run.nick
    #send_file file, type: "application/text", filename: run.nick + "." + parse(run).parser.to_s
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
      result = nil
      parsers = [WsplitParser.new, TimesplittrackerParser.new, SplitterzParser.new, LivesplitParser.new]
      parsers.each do |p|
        result = p.parse splits
        if result.present?
          result.parser = p.class.to_s.chomp("Parser").downcase
          break
        end
      end
      return nil if result.nil?
      # Set a `time` method for splits that converts best_time objects to floats
      if result.parser == "wsplit"
        result.splits.first.class.send(:define_method, :time) {
          self_index = self.parent.splits.index(self)
          if self_index == 0
            self.run_time.to_s.to_f
          else
            self.run_time.to_s.to_f - self.parent.splits.at(self_index - 1).run_time.to_s.to_f
          end
        }
      else
        result.splits.first.class.send(:define_method, :time) { self.best_time.to_s.to_f }
      end
      # Set a `time` method for the run that returns the total run time
      def result.time
        self.splits.inject(0) { |sum, split| sum += split.time }
      end
      # Set a `finish_time` method for splits that returns the run time when the split finished
      result.splits.first.class.send(:define_method, :finish_time) { self.parent.splits.first(self.parent.splits.index(self)+1).inject(0) { |sum, split| sum += split.time.to_s.to_f } }
      return result
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
