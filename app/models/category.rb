class Category < ApplicationRecord
  belongs_to :game
  has_many :runs
  has_many :rivalries, dependent: :destroy

  before_create :autodetect_shortname

  def self.from_name(name)
    return nil if name.blank?
    name = name.strip
    where("lower(name) = lower(?)", name).first
  end

  def self.from_name!(name)
    return nil if name.blank?
    name = name.strip
    where("lower(name) = lower(?)", name).first_or_create(name: name)
  end

  def runners
    User.that_run(self)
  end

  def best_known_run(timing)
    case timing
    when 'real'
      runs.unarchived.where.not(realtime_duration_ms: 0).order(realtime_duration_ms: :asc).first
    when 'game'
      runs.unarchived.where.not(gametime_duration_ms: 0).order(gametime_duration_ms: :asc).first
    end
  end

  def to_s
    name
  end

  def to_param
    id.to_s
  end

  def autodetect_shortname
    shortname = {
      "any%" => "anypct",
      "100%" => "100pct",
    }[name.try(:downcase)]
  end

  def shortname
    name.downcase.gsub(/ *%/, 'pct').gsub(/ +/, "-")
  end

  def popular?
    runs.count * 10 >= game.runs.count
  end

  # merge_into! changes ownership of all of this category's runs and rivalries to the given category, then destroys this
  # category.
  def merge_into!(category)
    ApplicationRecord.transaction do
      runs.update_all(category_id: category.id)
      rivalries.update_all(category_id: category.id)
      destroy
    end
  end
end
