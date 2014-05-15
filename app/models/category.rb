class Category < ActiveRecord::Base
  belongs_to :game
  has_many :runs

  def self.search(term)
    where(Category.arel_table[:name].matches "%#{term}%")
  end

  def best_known_run
    runs.order(:time).first
  end
end
