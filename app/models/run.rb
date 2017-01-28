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

  belongs_to :user
  belongs_to :category
  belongs_to :run_file, primary_key: :digest, foreign_key: :run_file_digest
  has_one :game, through: :category

  has_secure_token :claim_token

  after_create -> { parse(fast: true) if run_file.present? }
  after_create :refresh_game
  after_create :discover_runner

  after_destroy :remove_file

  #validates :run_file, presence: true
  validates_with RunValidator

  scope :by_game, ->(game_or_games) { joins(:category).where(categories: {game_id: game_or_games}) }
  scope :by_category, ->(category) { where(category: category) }
  scope :nonempty, -> { where("time != 0") }
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
    parse[:offset]
  end

  def program
    timer
  end

  def timer
    p = read_attribute(:program)
    if p.present?
      return p
    end

    r = dynamodb_info
    if r.nil?
      parse_into_dynamodb
      r = dynamodb_info
    end

    r['timer']
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
    "Any %" => "Any%"
  }

  def populate_category(game_string, category_string)
    category_string = CATEGORY_ALIASES.fetch(category_string, category_string)

    if category.blank? && game_string.present? && category_string.present?
      game = Game.from_name!(game_string)
      self.category = game.categories.where("lower(name) = lower(?)", category_string).first_or_create(name: category_string)
    end
  end

  def file
    if id36.present?
      file = $s3_bucket.object("splits/#{id36}")
      file.get.body.read
    else
      run_file.try(:file)
    end
  rescue Aws::S3::Errors::NoSuchKey, Aws::S3::Errors::AccessDenied
    run_file.try(:file)
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

  def remove_file
    if run_file.nil?
      $s3_bucket.object("splits/#{id36}").delete
    else
      if run_file.runs.count.zero?
        run_file.destroy
      end
    end
  end

  def filename(timer: Run.program(self.timer))
    "#{to_param}.#{timer.file_extension}"
  end

  def original_file
    if timer.to_sym == :llanfair && file[0] == "["
      RunFile.pack_binary(file)
    else
      file
    end
  end
end
