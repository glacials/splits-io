class Api::V1::CategoriesController < Api::V1::ApplicationController
  def index
    render json: (@records.map do |record|
      {
        id:             record.id,
        name:           record.name,
        game_id:        record.game_id,
        created_at:     record.created_at,
        updated_at:     record.updated_at,
        best_known_run: record.best_known_run.try(:id)
      }
    end), serializer: nil
  end

  def show
    render json: {
      id:             @record.id,
      name:           @record.name,
      game_id:        @record.game_id,
      created_at:     @record.created_at,
      updated_at:     @record.updated_at,
      best_known_run: @record.best_known_run.try(:id)
    }, serializer: nil
  end

  private

  def safe_params
    [:game_id]
  end

  def model
    Category
  end
end
