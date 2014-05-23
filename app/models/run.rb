require 'livesplit_parser'
require 'splitterz_parser'
require 'time_split_tracker_parser'
require 'wsplit_parser'

class Run < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  belongs_to :user
  belongs_to :category
  default_scope { order('created_at DESC') }

  before_create :generate_nick

  delegate :game, to: :category
  delegate :program, :name, :splits, :offset, :attempts, :run_history, to: :parse

  class << self; attr_accessor :parsers end
  @parsers = [WSplitParser, TimeSplitTrackerParser, SplitterZParser, LiveSplitParser]
  @parse_cache = nil

  # Takes care of skipped (e.g. missed) splits. If a run has no skipped splits, this method doesn't do anything.
  # If it does, the skipped splits are rolled into the soonest future split that wasn't skipped. This also works when
  # several splits in a row are skipped.
  def reduced_splits
    splits.reduce([]) do |splits, split|
      splits + [((splits.last.try(:duration) == 0 ? splits.last : []) + [split]).extend(Split)]
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
    splits.map(&:duration).sum
  end

  def parses
    parse
  end

  def parsed
    parse
  end

  def parse
    return @parse_cache if @parse_cache.present?

    Run.parsers.each do |p|
      result = p.new.parse(file)
      if result.present?
        result.program = p.name.sub('Parser', '').downcase.to_sym
        @parse_cache = result
        return result
      end
    end

    nil
  rescue ArgumentError # comes from non UTF-8 files
    nil
  end
end
