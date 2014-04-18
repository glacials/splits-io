class Game < ActiveRecord::Base
  has_many :categories

  def self.search(term)
    self.where('name LIKE ?', "%#{term}%")
  end
end
