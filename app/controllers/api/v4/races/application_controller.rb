class Api::V4::Races::ApplicationController < Api::V4::ApplicationController
  before_action :set_races, only: [:index]
  before_action :set_race,  only: [:show]

  def index
  end

  def show
  end
end
