class Category < ActiveRecord::Base
  belongs_to :game, touch: true
  has_many :runs

  before_create :autodetect_shortname

  def best_known_run
    return nil if name.nil?
    runs.where("time != 0").order(:time).first
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

  def to_param
    shortname || id.to_s
  end

  def autodetect_shortname
    shortname = {
      "any%" => "anypct",
      "100%" => "100pct",
    }[name.try(:downcase)]
  end
end
