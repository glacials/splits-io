Dir['./lib/programs/*'].each { |file| require file }
require './lib/parser/livesplit_core_parser'

class Run < ApplicationRecord
  include CompletedRun
  include ForgetfulPersonsRun
  include PadawanRun
  include S3Run
  include SRDCRun
  include UnparsedRun

  include ActionView::Helpers::DateHelper

  # Timing types
  REAL = 'real'.freeze
  GAME = 'game'.freeze

  ALLOWED_PROGRAM_METHODS = %i[to_s to_sym file_extension website content_type].freeze

  belongs_to :user
  belongs_to :category
  has_one :game, through: :category
  has_many :segments, dependent: :destroy
  # dependent: :delete_all requires there be no child records that need to be deleted
  # If RunHistory is changed to have child records, change this back to just :destroy
  has_many :histories, class_name: 'RunHistory', dependent: :delete_all

  has_secure_token :claim_token

  after_create :refresh_game
  after_create :discover_runner
  after_create :publish_aging

  validates_with RunValidator

  scope :by_game, ->(game_or_games) { joins(:category).where(categories: {game_id: game_or_games}) }
  scope :by_category, ->(category) { where(category: category) }
  scope :nonempty, -> { where('realtime_duration_ms != 0') }
  scope :owned, -> { where.not(user: nil) }
  scope :unarchived, -> { where(archived: false) }
  scope :categorized, lambda {
    joins(:category).where.not(categories: {name: nil}).joins(:game).where.not(games: {name: nil})
  }

  class << self
    def programs
      [
        ShitSplit, Splitty, Llanfair2, FaceSplit, Portal2LiveTimer,
        LlanfairGered, Llanfair, Urn, LiveSplit, SplitterZ, TimeSplitTracker, WSplit
      ]
    end

    def exportable_programs
      Run.programs.select(&:exportable)
    end

    def program(string_or_symbol)
      return string_or_symbol if Run.programs.include?(string_or_symbol)

      program_strings = Run.programs.map(&:to_sym).map(&:to_s)
      h = Hash[program_strings.zip(Run.programs)]
      h[string_or_symbol.to_s]
    end

    def program_from_attribute(func_name, value)
      raise 'not a valid attribute' unless ALLOWED_PROGRAM_METHODS.include?(func_name)
      Run.programs.find { |program| program.send(func_name) == value }
    end

    alias find10 find
    def find36(id36)
      find10(id36.to_i(36))
    end
  end

  alias id10 id
  def id36
    return nil if id10.nil?

    id10.to_s(36)
  end

  def belongs_to?(user)
    user.present? && self.user == user
  end

  def time_since_upload
    time_ago_in_words(created_at).sub('about ', '')
  end

  def offset
    0 # TODO: Replace with real offset
  end

  def timer
    program
  end

  def to_param
    id36
  end

  def to_s
    return '(no title)' if game.blank?
    game.name + (category.present? ? " #{category.name}" : '')
  end

  def path
    "/#{to_param}"
  end

  def populate_category(game_string, category_string)
    category_string = Category.global_aliases.fetch(category_string, category_string)

    return if category.present? || game_string.blank? || category_string.blank?

    game = Game.from_name!(game_string)
    self.category = game.categories.where('lower(name) = lower(?)', category_string).first_or_create(
      name: category_string
    )
  end

  def refresh_game
    return if game.blank?
    game.delay.sync_with_srl
  end

  # If we don't have a user assigned but we do have a speedrun.com run assigned, try to fetch the user from
  # speedrun.com. For this to work that user must have their Twitch account tied to both Splits I/O and speedrun.com.
  def discover_runner
    return if user.present?
    delay.set_runner_from_srdc
  end

  def filename(timer: Run.program(self.timer))
    "#{to_param}.#{timer.file_extension}"
  end

  def publish_aging
    publish_age_every(:minute, 60)
    publish_age_every(:hour, 24)
    publish_age_every(:day, 30)
  end

  private

  def publish_age_every(time, limit)
    limit.times do |i|
      RunChannel.delay(run_at: Time.now.utc + (i + 1).send(time)).broadcast_time_since_upload(id36)
    end
  end
end
