class Category < ActiveRecord::Base
  belongs_to :game
  has_many :runs

  def self.search(term)
    self.where('name LIKE ?', "%#{term}%")
  end
end
