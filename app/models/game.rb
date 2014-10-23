class Game < ActiveRecord::Base
  has_many :categories
  has_many :runs, through: :categories

  def self.search(term)
    t = Game.arel_table
    where(t[:name].matches("%#{term}%").or(t[:shortname].eq(term))).order(:name)
  end

  def as_json(options = {})
    super({
      only: [:id, :name, :created_at, :updated_at, :shortname]
    }.merge(options))
  end

  def to_param
    shortname || name.downcase.gsub(' ', '+')
  end
end
