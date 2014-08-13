require 'livesplit_parser'
require 'splitterz_parser'
require 'time_split_tracker_parser'
require 'wsplit_parser'

class Run < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  belongs_to :user
  belongs_to :category
  has_one :game, through: :category

  before_create :generate_nick

  class << self; attr_accessor :parsers end
  @parsers = [WSplitParser, TimeSplitTrackerParser, SplitterZParser, LiveSplitParser]
  @parse_cache = nil

  def self.find(id)
    if id.is_a? Integer
      super(id)
    else
      find_by(nick: id) || super(id.to_i(36))
    end
  end

  def self.by_category(category)
    where(category: category)
  end

  def self.by_game(game)
    joins(:category).where('categories.game_id = %d' % game.id)
  end

  def self.search(term)
    where(Run.arel_table[:name].matches "%#{term}%").order(:name)
  end

  # Takes care of skipped (e.g. missed) splits. If a run has no skipped splits, this method just returns `splits`.
  # If it does, the skipped splits are rolled into the soonest future split that wasn't skipped.
  def reduced_splits
    splits.reduce([]) do |splits, split|
      if splits.last.try(:[], :duration) == 0
        skipped_split = splits.last
        splits + [splits.pop.merge({
            duration:    split[:duration],
            name:        "#{skipped_split[:name]} + #{split[:name]}",
            finish_time: split[:finish_time]
          }
        )]
      else
        splits + [split]
      end
    end
  end

  def generate_nick
    loop do
      self.nick = SecureRandom.urlsafe_base64(3)
      return if Run.find_by(nick: nick).nil?
    end
  end

  def belongs_to?(user)
    user.present? && self.user == user
  end

  def time_since_upload
    time_ago_in_words(created_at).sub('about ', '')
  end

  def new?
    hits <= 1
  end

  def to_param
    nick.present? ? nick : read_attribute(:id).to_s(36)
  end

  def disown
    self.user = nil
  end

  def hit
    self.hits += 1
  end

  def disown
    self.user = nil
  end

  def time
    (read_attribute(:time) || update_attribute(:time, splits.map { |s| s[:duration] }.sum) && read_attribute(:time)).to_f
  end

  def name
    read_attribute(:name) || update_attribute(:name, parse[:name]) && read_attribute(:name)
  end

  def splits
    parse[:splits]
  end

  def program
    parse[:program]
  end

  def offset
    parse[:offset]
  end

  def attempts
    parse[:attempts]
  end

  def history
    parse[:history]
  end

  def as_json(options)
    super(except: 'file')
  end

  def parses?
    !!parse
  end

  def parse
    return @parse_cache if @parse_cache.present?

    Run.parsers.each do |p|
      result = p.new.parse(file)
      if result.present?
        result[:program] = p.name.sub('Parser', '').downcase.to_sym
        @parse_cache = result
        return result
      end
    end

    nil
  rescue ArgumentError # comes from non UTF-8 files
    nil
  end

  def tracking_info
    { 'Parses?'     => parses?,
      'Screenshot?' => image_url.present?
    }.merge(parses? ? {
      'Game'        => game.name,
      'Category'    => category.name,
      'Program'     => program,
      'Offset'      => offset
    } : {})
  end
end
