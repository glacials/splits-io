class Api::V4::SpeedrunsliveRacesController < Api::V4::ApplicationController
  def index
    Rails.cache.fetch('srl_races', expires_in: 1.minute) do
      render json: SpeedRunsLive::Race.all
    end
  end
end
