require 'speedrunslive'

class Game < ActiveRecord::Base
  include SRLGame

  validates :name, presence: true

  has_many :categories
  has_many :runs, through: :categories
  has_many :aliases, class_name: 'Game::Alias'

  after_create :create_alias
  after_touch :destroy, if: Proc.new { |game| game.categories.count.zero? }

  scope :named, -> { where.not(name: nil) }

  def self.search(term)
    return nil if term.blank?
    joins(:aliases).where('game_aliases.name LIKE ? OR games.shortname = ?', "%#{term}%", term).order(:name)
  end

  def self.from_name(name)
    return nil if name.blank?
    joins(:aliases).where(aliases: {name: name}).first_or_create(name: name)
  end

  def to_param
    shortname || name.downcase.gsub('/', '')
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
    categories.joins(:runs).group('categories.id').having('count(runs.id) >= ' + (Run.where(category: categories.pluck(:id)).count / 20).to_s).order('count(runs.id) desc')
  end

  def unpopular_categories
    categories.joins(:runs).group('categories.id').having('count(runs.id) < ' + (Run.where(category: categories.pluck(:id)).count / 20).to_s).order('count(runs.id) desc')
  end

  private

  def create_alias
    aliases.create(name: name)
  end
end
