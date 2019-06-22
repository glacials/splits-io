class Api::V4::Races::Entries::BingosController < Api::V4::Races::Entries::ApplicationController
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
