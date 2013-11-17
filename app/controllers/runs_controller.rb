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
    run = Run.find_by nick: params[:nick]
    file = Rails.root.join "private", "runs", run.nick
    wsplit_data = WsplitParser.new.parse File.read(file)
    if wsplit_data.present?
      @run = wsplit_data
      render :wsplit
    end
  end

  def new_nick
    nick = SecureRandom.urlsafe_base64(4)
    while Run.find_by(nick: nick).present?
      nick = SecureRandom.urlsafe_base64(4)
    end
    nick
  end
end
