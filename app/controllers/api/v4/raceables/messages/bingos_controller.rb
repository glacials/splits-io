class Api::V4::Raceables::Messages::BingosController < Api::V4::Raceables::Messages::ApplicationController
  def index
    super
  end

  def create
    super
  end

  private

  def set_raceable
    super(Bingo)
  end
end
