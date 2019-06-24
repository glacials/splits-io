class Api::V4::Raceables::Messages::BingosController < Api::V4::Raceables::Messages::ApplicationController
  private

  def set_raceable
    super(Bingo)
  end
end
