class Api::V4::Races::Messages::BingosController < Api::V4::Races::Messages::ApplicationController
  private

  def set_raceable
    super(Bingo)
  end
end
