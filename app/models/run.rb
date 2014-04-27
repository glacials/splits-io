require 'livesplit_parser'
require 'splitterz_parser'
require 'time_split_tracker_parser'
require 'wsplit_parser'

class Run < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  delegate :game, to: :category

  before_create :generate_nick

  @@parsers = [WSplitParser, TimeSplitTrackerParser, SplitterZParser, LiveSplitParser]
  @parse_cache = nil

  def generate_nick
    loop do
      self.nick = SecureRandom.urlsafe_base64(3)
      return if Run.find_by(nick: self.nick).nil?
    end
  end

  def game
    read_attribute(:game) || self.parse.game
  end

  def category
    read_attribute(:category) || self.parse.category
  end

  def disown
    self.user = nil
  end

  def program
    self.parse.program
  end

  def name
    self.parse.name
  end

  def splits
    self.parse.splits
  end

  def time
    self.splits.map(&:duration).sum
  end

  def offset
    self.parse.offset
  end

  def attempts
    self.parse.attempts
  end

  def run_history
    self.parse.run_history
  end

  def parses
    self.parse
  end

  def parsed
    self.parse
  end

  def parse
    if @parse_cache.present?
      return @parse_cache
    end

    begin
      @@parsers.each do |p|
        result = p.new.parse(file)
        if result.present?
          result.program = p.name.sub('Parser', '').downcase.to_sym
          @parse_cache = result and return result
        end
      end
    rescue ArgumentError # comes from non UTF-8 files
      return nil
    end

    return nil
  end

end
