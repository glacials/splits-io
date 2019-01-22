require 'speedrunslive'

class Game < ApplicationRecord
  include PgSearch

  extend OrderAsSpecified

  validates :name, presence: true

  has_many :categories, dependent: :destroy
  has_many :runs, through: :categories
  has_many :users, -> { distinct }, through: :runs
  has_many :runners, -> { distinct }, through: :runs, class_name: 'User'
  has_many :aliases, class_name: 'GameAlias'

  has_one :srdc, class_name: 'SpeedrunDotComGame', dependent: :destroy
  has_one :srl,  class_name: 'SpeedRunsLiveGame',  dependent: :destroy

  after_create :create_initial_alias

  scope :named, -> { where.not(name: nil) }
  pg_search_scope :search_both_names,
                  against: %i[name],
                  ignoring: :accents,
                  using: {
                    tsearch: {prefix: true},
                    trigram: {only: :name}
                  }

  def self.search(term)
    term.strip!
    return Game.none if term.blank?

    ids = Game.joins(:srdc, :aliases).merge(GameAlias.search_for_name(term)).pluck(:id)
    Game.where(id: ids).order_as_specified(id: ids)
  end

  def self.from_name(name)
    name = name.strip
    return nil if name.blank?
    joins(:aliases).where(game_aliases: {name: name}).first
  end

  def self.from_name!(name)
    name = name.strip
    return nil if name.blank?
    joins(:aliases).where(game_aliases: {name: name}).first_or_create(name: name)
  end

  def to_param
    srdc.try(:shortname) || id.to_s || name.downcase.delete('/')
  end

  def sync_with_srdc
    if srdc.nil?
      SpeedrunDotComGame.from_game!(self)
      return
    end

    srdc.sync!
  end

  def sync_with_srl
    if srl.nil?
      SpeedRunsLiveGame.from_game!(self)
      return
    end

    srl.sync!
  end

  def to_s
    name
  end

  def popular_categories
    categories.joins(:runs).group('categories.id')
              .having('count(runs.id) >= ' + (Run.where(category: categories).count * 0.05).to_s)
              .order(Arel.sql('count(runs.id) desc'))
  end

  def unpopular_categories
    categories.joins(:runs).group('categories.id')
              .having('count(runs.id) < ' + (Run.where(category: categories).count * 0.05).to_s)
              .order(Arel.sql('count(runs.id) desc'))
  end

  # merge_into! moves all categories, aliases, and runs over to the given game, then destroys this game. Use this when
  # there are two Splits I/O games representing the same game, like "Tron Evolution" and "Tron: Evolution".
  def merge_into!(game)
    ApplicationRecord.transaction do
      aliases.update_all(game_id: game.id)

      categories.each do |category|
        equiv = game.categories.find_by(name: category.name)
        equiv ? category.merge_into!(equiv) : category.update(game: game)
      end

      destroy
    end
  end

  private

  def create_initial_alias
    aliases.create(name: name)
  end
end
