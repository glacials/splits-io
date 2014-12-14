class Game < ActiveRecord::Base
  has_many :categories
  has_many :runs, through: :categories

  def self.search(term)
    t = self.arel_table
    where(t[:name].matches("%#{term}%").or(t[:shortname].eq(term))).order(:name)
  end

  def to_param
    shortname || name.downcase.gsub(' ', '+')
  end
end
