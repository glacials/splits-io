require 'livesplit_parser'
require 'splitterz_parser'
require 'time_split_tracker_parser'
require 'wsplit_parser'

class Run < ActiveRecord::Base
  include PadawanRun
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

  # Takes care of skipped (e.g. missed) splits. If a run has no skipped splits, this method just returns `splits`.
  # If it does, the skipped splits are rolled into the soonest future split that wasn't skipped.
  def reduced_splits
    splits.reduce([]) do |splits, split|
      if splits.last.try(:[], :duration) == 0
        skipped_split = splits.last
        splits + [splits.pop.merge(
          duration: split[:duration],
          name: "#{skipped_split[:name]} + #{split[:name]}",
          finish_time: split[:finish_time],
          reduced?: true
        )]
      else
        splits + [split]
      end
    end
  end

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

  def populate_category
    if category.blank? && parse[:game].present?
      self.category = Game.where(name: parse[:game]).first_or_create.categories.where(name: parse[:category]).first_or_create
    end
  end
end
