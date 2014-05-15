require 'livesplit_parser'
require 'splitterz_parser'
require 'time_split_tracker_parser'
require 'wsplit_parser'

class Run < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  belongs_to :user
  belongs_to :category
  delegate :game, to: :category
  default_scope { order('created_at DESC') }

  before_create :generate_nick

  @@parsers = [WSplitParser, TimeSplitTrackerParser, SplitterZParser, LiveSplitParser]
  @parse_cache = nil

  def generate_nick
    loop do
      nick = SecureRandom.urlsafe_base64(3)
      return if Run.find_by(nick: nick).nil?
    end
  end

  def time_since_upload
    time_ago_in_words(created_at).sub('about ', '')
  end

  def new?
    hits <= 1
  end

  def game
    self[:game] || parse.game
  end

  def category
    self[:category] || parse.category
  end

  def disown
    user = nil
  end

  def program
    parse.program
  end

  def name
    parse.name
  end

  def splits
    parse.splits
  end

  def time
    splits.map(&:duration).sum
  end

  def offset
    parse.offset
  end

  def attempts
    parse.attempts
  end

  def run_history
    parse.run_history
  end

  def parses
    parse
  end

  def parsed
    parse
  end

  def parse
    return @parse_cache if @parse_cache.present?

    begin
      @@parsers.each do |p|
        result = p.new.parse(file)
        if result.present?
          result.program = p.name.sub('Parser', '').downcase.to_sym
          @parse_cache = result
          return result
        end
      end
    rescue ArgumentError # comes from non UTF-8 files
      return nil
    end

    nil
  end
end
