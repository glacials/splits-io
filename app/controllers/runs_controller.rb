class RunsController < ApplicationController
  def new
  end
  def create
    splits = params[:file]
    run = Run.create(nick: new_nick, user: nil)
    File.open(Rails.root.join('private', 'runs', run.nick), 'wb') do |file|
      file.write(splits.read)
    end
    render text: run.nick
  end
  def popular
  end
  def front
  end
  def show
    @run = Run.find_by nick: params[:nick]
  end

  def new_nick
    nick = SecureRandom.urlsafe_base64(4)
    while Run.find_by(nick: nick).present?
      nick = SecureRandom.urlsafe_base64(4)
    end
    nick
  end
end
