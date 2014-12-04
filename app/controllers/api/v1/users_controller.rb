class Api::V1::UsersController < Api::V1::ApplicationController
  def index
    render json: (@records.map do |record|
      {
        id:         record.id,
        twitch_id:  record.twitch_id,
        name:       record.name,
        created_at: record.created_at,
        updated_at: record.updated_at
      }
    end), serializer: nil
  end

  def show
    render json: {
      id:         @record.id,
      twitch_id:  @record.twitch_id,
      name:       @record.name,
      created_at: @record.created_at,
      updated_at: @record.updated_at
    }, serializer: nil
  end

  private

  def safe_params
    [:twitch_id, :name]
  end

  def model
    User
  end
end
