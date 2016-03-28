# A Game::Alias is meant to be used as a mapping from an alternative game name to a game. The column used by
# Game::Alias#name is of type citext, which has case-insensitive lookups by nature. It is safe (and preferred) to look
# up games using
#
#   Game.joins(:aliases).find_by(aliases: {name: "tron: evolution"})
#
# which performs just one query. You can also use
#
#   Game::Alias.find_by(name: "Blah").game
#
# if you need to, which performs two queries. It is safe to expect that a Game#name will also be represented as a
# Game::Alias#name.
class Game::Alias < ActiveRecord::Base
  belongs_to :game, dependent: :destroy

  validates_uniqueness_of :name
  validates_presence_of :name

  def to_s
    name
  end
end
