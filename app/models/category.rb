class Category < ActiveRecord::Base
  belongs_to :game, touch: true
  has_many :runs

  def best_known_run
    runs.order(:time).first
  end

  def as_json(options = {})
    {
      id:             id,
      name:           name,
      game_id:        game_id,
      created_at:     created_at,
      updated_at:     updated_at,
      best_known_run: best_known_run.try(:id)
    }
  end

  def to_s
    name
  end
end
