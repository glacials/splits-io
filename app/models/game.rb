class Game < ActiveRecord::Base
  has_many :categories
  has_many :runs, through: :categories

  def self.search(term)
    where(Game.arel_table[:name].matches "%#{term}%").order(:name)
  end

  def to_s
    name
  end
end
