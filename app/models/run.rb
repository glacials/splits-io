require 'livesplit_parser'
require 'splitterz_parser'
require 'time_split_tracker_parser'
require 'wsplit_parser'
require 'urn_parser'

class Run < ActiveRecord::Base
  include PadawanRun
  include ForgetfulPersonsRun
  include ActionView::Helpers::DateHelper

  belongs_to :user, touch: true
  belongs_to :category, touch: true
  belongs_to :run_file, primary_key: :digest, foreign_key: :run_file_digest
  has_one :game, through: :category

  has_secure_token :claim_token

  after_create :refresh_game
  after_destroy do |run|
    if run.run_file.present? && run.run_file.runs.where.not(id: run).empty?
      run.run_file.destroy
    end
  end

  @parse_cache = nil

  validates_with RunValidator

  before_save :populate_category

  scope :by_game, ->(game) { joins(:category).where(categories: {game_id: game}) }
  scope :by_category, ->(category) { where(category: category) }
  scope :nonempty, -> { where("time != 0") }
  scope :owned, -> { where.not(user: nil) }
  scope :unarchived, -> { where(archived: false) }
  scope :categorized, -> { joins(:category).where.not(categories: {name: nil}).joins(:game).where.not(games: {name: nil}) }

  class << self
    def programs
      @@programs
    end

    @@programs = [Urn, LiveSplit, SplitterZ, TimeSplitTracker, WSplit]
    @@parsers = {
      wsplit: WSplitParser,
      timesplittracker: TimeSplitTrackerParser,
      splitterz: SplitterZParser,
      livesplit: LiveSplitParser,
      urn: UrnParser
    }

    inheritance_column = :program
    def find_sti_class(program)
      Hash[@@programs.map { |program| [program.to_s.downcase, program::Run] }][program]
    end

    alias_method :find10, :find
    # todo: rename this to `find` when APIv2 is removed
    def find36(id)
      find10(id.to_i(36))
    end
  end

  alias_method :id10, :id
  # todo: rename this to `id` when APIv2 is removed
  def id36
    id10.to_s(36)
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
    if @@parsers.keys.include?(read_attribute(:program))
      [@@parsers[read_attribute(:program)]]
    else
      @@parsers.values
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
    id36
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
    if [parse[:game], parse[:category]].all?(&:present?)
      [parse[:game], parse[:category]].each(&:strip!)

      game = Game.where("lower(name) = ?", parse[:game].downcase).first_or_create(name: parse[:game])
      category = game.categories.where("lower(name) = ?", parse[:category].downcase).first_or_create(name: parse[:category])

      update(category: category, archived: !pb?)
    end
  end

  def time
    read_attribute(:time).to_f
  end

  def file
    run_file.file
  end

  def refresh_game
    return if game.blank?
    game.delay.sync_with_srl
  end

  def has_golds?
    splits.all? { |split| split.best.duration.present? }
  end

  def filename(download_program)
    extension = {'livesplit' => 'lss', 'urn' => 'json'}[download_program] || download_program
    "#{to_param}.#{extension}"
  end
end
