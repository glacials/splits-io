class Game < ActiveRecord::Base
  has_many :categories

  def self.search(term)
    self.where(Game.arel_table[:name].matches "%#{term}%")
  end
end
