require 'livesplit_parser'
require 'splitterz_parser'
require 'time_split_tracker_parser'
require 'wsplit_parser'

class Run < ActiveRecord::Base
  include PadawanRun
  include ForgetfulPersonsRun
  include ActionView::Helpers::DateHelper

  belongs_to :user, touch: true
  belongs_to :category, touch: true
  has_one :game, through: :category

  class << self; attr_accessor :parsers end
  @parsers = {
    wsplit: WSplitParser,
    timesplittracker: TimeSplitTrackerParser,
    splitterz: SplitterZParser,
    livesplit: LiveSplitParser
  }
  @parse_cache = nil

  validates :file, presence: true

  before_save :populate_category

  scope :by_game, ->(game) { joins(:category).where(categories: {game_id: game}) }
  scope :by_category, ->(category) { where(category: category) }
  scope :without, ->(*columns) { select(column_names - columns.map(&:to_s)) }
  scope :nonempty, -> { where("time != 0") }

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

      # Set some db fields
      assign_attributes(program: result[:program])                                  if read_attribute(:program).blank?
      assign_attributes(time:    result[:splits].map { |s| s[:duration] }.sum.to_f) if read_attribute(:time).blank?
      assign_attributes(name:    result[:name])                                     if read_attribute(:name).blank?

      # temporary; re-determine game/category from splits because of a db screwup i made
      if category.try(:name).try(:downcase) != result[:category].try(:downcase) || game.try(:name).try(:downcase) != result[:game].try(:downcase)
        populate_category(true)
        save
      end

      @parse_cache = result
      return result
    end
    {}
  rescue ArgumentError # comes from non UTF-8 files
    {}
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
    user && category && time == user.pb_for(category).time
  end

  private

  def populate_category(force = false)
    if force || (category.blank? && parse[:game].present?)
      game = Game.where("lower(name) = ?", parse[:game].downcase).first_or_create(name: parse[:game])
      self.category = game.categories.where("lower(name) = ?", parse[:category].downcase).first_or_create(name: parse[:category])
    end
  end
end
