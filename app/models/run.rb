require 'livesplit_parser'
require 'splitterz_parser'
require 'time_split_tracker_parser'
require 'wsplit_parser'

class Run < ActiveRecord::Base
  include PadawanRun
  include ForgetfulPersonsRun
  include ActionView::Helpers::DateHelper

  self.inheritance_column = :program
  def self.find_sti_class(program)
    {
      'livesplit' => LiveSplit::Run,
      'wsplit' => WSplit::Run,
      'timesplittracker' => TimeSplitTracker::Run,
      'splitterz' => SplitterZ::Run
    }[program]
  end

  belongs_to :user, touch: true
  belongs_to :category, touch: true
  belongs_to :run_file, primary_key: :digest, foreign_key: :run_file_digest
  has_one :game, through: :category

  has_secure_token :claim_token

  after_create :refresh_game

  class << self; attr_accessor :parsers end
  @parsers = {
    wsplit: WSplitParser,
    timesplittracker: TimeSplitTrackerParser,
    splitterz: SplitterZParser,
    livesplit: LiveSplitParser
  }
  @parse_cache = nil

  validates :file, presence: true
  validates_with RunValidator

  before_save :populate_category

  default_scope { select(column_names - ['file']) }
  scope :by_game, ->(game) { joins(:category).where(categories: {game_id: game}) }
  scope :by_category, ->(category) { where(category: category) }
  scope :nonempty, -> { where("time != 0") }
  scope :owned, -> { where.not(user: nil) }
  scope :unarchived, -> { where(archived: false) }
  scope :categorized, -> { joins(:category).where.not(categories: {name: nil}).joins(:game).where.not(games: {name: nil}) }

  def belongs_to?(user)
    user.present? && self.user == user
  end

  def time_since_upload
    time_ago_in_words(created_at).sub('about ', '')
  end

  def splits
    parse[:splits]
  end

  def program
    (read_attribute(:program) || parse[:program]).to_sym
  end

  def offset
    parse[:offset]
  end

  def attempts
    parse[:attempts]
  end

  def short?
    time < 20.minutes
  end

  def history
    parse[:history]
  end

  def parses?
    parse.present?
  end

  def parse
    return @parse_cache if @parse_cache.present?
    if Run.parsers.keys.include?(read_attribute(:program))
      [Run.parsers[read_attribute(:program)]]
    else
      Run.parsers.values
    end.each do |parser|
      result = parser.new.parse(file)
      next if result.blank?
      result[:program] = parser.name.sub('Parser', '').downcase.to_sym

      assign_attributes(
        name: result[:name],
        program: result[:program],
        time: result[:splits].map { |split| split.duration }.sum.to_f,
        sum_of_best: result[:splits].map.all? do |split|
          split.best.duration.present?
        end && result[:splits].map do |split|
          split.best.duration
        end.sum.to_f
      )

      @parse_cache = result

      return result
    end
    {}
  rescue ArgumentError # comes from non UTF-8 files
    {
      error: "Your file wasn't UTF-8 encoded. Usually this means it didn't come straight from your program, but from some
      other source. If the file was sent to you by a friend, make sure the file as a whole is sent, not just the text inside it."
    }
  end

  def to_param
    id.to_s(36)
  end

  def path
    "/#{to_param}"
  end

  def best_known?
    category && time == category.best_known_run.try(:time)
  end

  def pb?
    user && category && self == user.pb_for(category)
  end

  def populate_category
    if (category.blank? && parse[:game].present? && parse[:category].present?)
      game = Game.where("lower(name) = ?", parse[:game].downcase).first_or_create(name: parse[:game])
      self.category = game.categories.where("lower(name) = ?", parse[:category].downcase).first_or_create(name: parse[:category])
    end
  end

  def refresh_from_file
    game = Game.where("lower(name) = ?", parse[:game].try(:downcase)).first || Game.create(name: parse[:game])
    update_attributes(
      category: game.categories.where("lower(name) = ?", parse[:category].try(:downcase)).first_or_create(name: parse[:category]),
      archived: !pb?
    )
  end

  def time
    read_attribute(:time).to_f
  end

  # Our default scope doesn't select file because it's potentially really, really big. This method lets us still access
  # it normally, through a secondary query.
  def file
    run_file.try(:file) || read_attribute(:file) || Run.unscoped.find(self).read_attribute(:file)
  end

  def refresh_game
    return if game.blank?
    game.delay.sync_with_srl
  end

  def has_golds?
    splits.all? { |split| split.best.duration.present? }
  end
end
