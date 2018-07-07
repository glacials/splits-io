require 'speedrunslive'

class Game < ApplicationRecord
  include PgSearch
  include SRLGame

  validates :name, presence: true

  has_many :categories, dependent: :destroy
  has_many :runs, through: :categories
  has_many :users, -> { distinct }, through: :runs
  has_many :runners, -> { distinct }, through: :runs, class_name: 'User'
  has_many :aliases, class_name: 'GameAlias'

  after_create :create_initial_alias

  scope :named, -> { where.not(name: nil) }
  scope :shortnamed, -> { where.not(shortname: nil) }
  pg_search_scope :search_both_names,
                  against: %i[name shortname],
                  using: {
                    tsearch: {},
                    trigram: {only: :name}
                  }

  def self.search(term)
    term.strip!
    return Game.none if term.blank?

    Game.joins(:aliases).merge(GameAlias.search_for_name(term)).uniq
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
    shortname || id.to_s || name.downcase.delete('/')
  end

  def sync_with_srl
    return if shortname.present?
    game = ::SpeedRunsLive.game(name)
    return if game.nil?

    update(shortname: game['abbrev'])
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

  # merge_into! changes ownership of this game's categories and aliases to the given game, then destroys this game.
  def merge_into!(game)
    ApplicationRecord.transaction do
      game.update(shortname: game.shortname || shortname)
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
