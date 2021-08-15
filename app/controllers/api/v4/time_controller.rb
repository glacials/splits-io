class Api::V4::TimeController < Api::V4::ApplicationController
  skip_before_action :track

  def create
    render status: :ok, json: {
      status: 200,
      id:     params[:id],
      result: Time.now.utc.to_f * 1000
    }
  end
end
