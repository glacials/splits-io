# GameAlias is meant to be used as a mapping from an alternative game name to a game. The column used by GameAlias#name
# is of type citext, which has case-insensitive lookups by nature. It is safe (and preferred) to look up games using
#
#   Game.joins(:aliases).find_by(aliases: {name: "tron: evolution"})
#
# which performs just one query. You can also use
#
#   GameAlias.find_by(name: "Blah").game
#
# if you need to, which performs two queries. It is safe to expect that a Game#name will also be represented as a
# GameAlias#name.
class GameAlias < ApplicationRecord
  include PgSearch
  belongs_to :game, dependent: :destroy

  validates :name, uniqueness: true
  validates :name, presence: true

  pg_search_scope :search_for_name,
                  against: %i[name],
                  using: {
                    tsearch: {prefix: true},
                    trigram: {only: :name}
                  }

  def to_s
    name
  end
end
