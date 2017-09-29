Dir['./lib/parsers/*'].each { |file| require file }

class Run < ApplicationRecord
  include CompletedRun
  include DynamoDBRun
  include ForgetfulPersonsRun
  include PadawanRun
  include S3Run
  include SRDCRun
  include UnparsedRun

  include ActionView::Helpers::DateHelper

  # Timing types
  REAL = 'real'
  GAME = 'game'

  belongs_to :user
  belongs_to :category
  has_one :game, through: :category
  has_many :segments, dependent: :destroy

  has_secure_token :claim_token

  after_create :refresh_game
  after_create :discover_runner

  validates_with RunValidator

  scope :by_game, ->(game_or_games) { joins(:category).where(categories: {game_id: game_or_games}) }
  scope :by_category, ->(category) { where(category: category) }
  scope :nonempty, -> { where("realtime_duration_ms != 0") }
  scope :owned, -> { where.not(user: nil) }
  scope :unarchived, -> { where(archived: false) }
  scope :categorized, -> { joins(:category).where.not(categories: {name: nil}).joins(:game).where.not(games: {name: nil}) }

  class << self
    def programs
      [LlanfairGered, Llanfair, Urn, LiveSplit, SplitterZ, TimeSplitTracker, WSplit]
    end

    def exportable_programs
      [Urn, LiveSplit, SplitterZ, TimeSplitTracker, WSplit]
    end

    def program(string_or_symbol)
      if Run.programs.include?(string_or_symbol)
        return string_or_symbol
      end

      program_strings = Run.programs.map(&:to_sym).map(&:to_s)
      h = Hash[program_strings.zip(Run.programs)]
      h[string_or_symbol.to_s]
    end

    def program_from_content_type(content_type_string)
      Run.exportable_programs.each do |prg|
        return prg if prg.content_type == content_type_string
      end
      return nil
    end

    alias_method :find10, :find
    def find36(id36)
      find10(id36.to_i(36))
    end
  end

  alias_method :id10, :id
  def id36
    if id10.nil?
      return nil
    end

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
    if game.present? && category.present?
      return "#{game.name} #{category.name}"
    end

    if game.present?
      return game.name
    end

    return "(no title)"
  end

  def path
    "/#{to_param}"
  end

  CATEGORY_ALIASES = {
    "Any% (NG+)" => "Any% NG+",
    "Any% (New Game+)" => "Any% NG+",
    "Any %" => "Any%",
    "All Skills No OOB" => "All Skills no OOB no TA" # for ori_de
  }

  def populate_category(game_string, category_string)
    category_string = CATEGORY_ALIASES.fetch(category_string, category_string)

    if category.blank? && game_string.present? && category_string.present?
      game = Game.from_name!(game_string)
      self.category = game.categories.where("lower(name) = lower(?)", category_string).first_or_create(name: category_string)
    end
  end

  def file
    file = $s3_bucket_internal.object("splits/#{s3_filename}")
    file.get.body.read
  rescue Aws::S3::Errors::NoSuchKey, Aws::S3::Errors::AccessDenied
    nil
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

  def duration_ms(time_type = default_time_type)
    case time_type
    when Run::REAL
      realtime_duration_ms
    when Run::GAME
      gametime_duration_ms
    end
  end

  def sum_of_best_ms(time_type = default_time_type)
    case time_type
    when Run::REAL
      realtime_sum_of_best_ms
    when Run::GAME
      gametime_sum_of_best_ms
    end
  end
end
