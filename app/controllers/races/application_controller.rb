class Races::ApplicationController < ApplicationController
  before_action :set_race,     only: [:show]
  before_action :set_race_gon, only: [:show]

  def show
  end

  private

  def set_race_gon
    gon.race = {
      id:         @race.id,
      type:       @race.type,
      join_token: params[:join_token]
    }
  end
end
