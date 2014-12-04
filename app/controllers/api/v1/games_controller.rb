class Api::V1::GamesController < Api::V1::ApplicationController
  def index
    render json: (@records.map do |record|
      {
        id:         record.id,
        name:       record.name,
        shortname:  record.shortname,
        created_at: record.created_at,
        updated_at: record.updated_at,
        categories: record.categories.map do |category|
          {
            id:             category.id,
            name:           category.name,
            game_id:        category.game_id,
            created_at:     category.created_at,
            updated_at:     category.updated_at,
            best_known_run: category.best_known_run.try(:id)
          }
        end
      }
    end), serializer: nil
  end

  def show
    render json: {
      id:         @record.id,
      name:       @record.name,
      shortname:  @record.shortname,
      created_at: @record.created_at,
      updated_at: @record.updated_at,
      categories: @record.categories
    }, serializer: nil
  end

  private

  def safe_params
    [:name, :shortname]
  end

  def model
    Game
  end
end
