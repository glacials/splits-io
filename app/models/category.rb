class Category < ActiveRecord::Base
  belongs_to :game
  has_many :runs

  def best_known_run
    runs.order(:time).first
  end

  def as_json(options = {})
    super({
      only: [:id, :name, :created_at, :updated_at]
    }.merge(options))
  end

  def to_s
    name
  end
end
