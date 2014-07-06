class Category < ActiveRecord::Base
  belongs_to :game
  has_many :runs

  def best_known_run
    runs.order(:time).first
  end
end
