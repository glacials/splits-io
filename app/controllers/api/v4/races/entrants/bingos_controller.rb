class Api::V4::Race::Entrants::BingosController < Api::V4::Races::Entrants::ApplicationController
  def create
    super
  end

  def update
    super
  end

  def destroy
    super
  end

  private

  def set_raceable
    super(Bingo)
  end
end
