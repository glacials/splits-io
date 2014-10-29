class Game < ActiveRecord::Base
  has_many :categories
  has_many :runs, through: :categories

  def self.search(term)
    t = Game.arel_table
    where(t[:name].matches("%#{term}%").or(t[:shortname].eq(term))).order(:name)
  end

  def as_json(options = {})
    {
      id:         id,
      name:       name,
      shortname:  shortname,
      created_at: created_at,
      updated_at: updated_at,
      categories: categories
    }
  end

  def to_param
    shortname || name.downcase.gsub(' ', '+')
  end
end
