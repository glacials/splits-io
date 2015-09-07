Dir['./lib/parsers/*'].each { |file| require file }

class Run < ActiveRecord::Base
  include PadawanRun
  include ForgetfulPersonsRun
  include SRDCRun
  include CompletedRun

  include ActionView::Helpers::DateHelper

  belongs_to :user, touch: true
  belongs_to :category, touch: true
  belongs_to :run_file, primary_key: :digest, foreign_key: :run_file_digest
  has_one :game, through: :category

  has_secure_token :claim_token

  after_create :refresh_game
  after_create :discover_runner

  after_update :discover_runner

  after_destroy do |run|
    if run.run_file.present? && run.run_file.runs.where.not(id: run).empty?
      run.run_file.destroy
    end
  end

  validates :run_file, presence: true
  validates_with RunValidator

  before_save :set_name

  scope :by_game, ->(game) { joins(:category).where(categories: {game_id: game}) }
  scope :by_category, ->(category) { where(category: category) }
  scope :nonempty, -> { where("time != 0") }
  scope :owned, -> { where.not(user: nil) }
  scope :unarchived, -> { where(archived: false) }
  scope :categorized, -> { joins(:category).where.not(categories: {name: nil}).joins(:game).where.not(games: {name: nil}) }

  class << self
    def programs
      [Llanfair, Urn, LiveSplit, SplitterZ, TimeSplitTracker, WSplit]
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

  def runners
    [user]
  end

  def time_since_upload
    time_ago_in_words(created_at).sub('about ', '')
  end

  def offset
    parse[:offset]
  end

  def parses?
    parse.present?
  end

  def parse(fast: true)
    return @parse_cache[fast] if @parse_cache.try(:[], fast).present?
    if Run.programs.map(&:to_sym).include?(program.try(:to_sym))
      [Run.programs[Run.programs.map(&:to_sym).index(program.to_sym)]]
    else
      Run.programs
    end.each do |program|
      result = program::Parser.new.parse(file, fast: fast)
      next if result.blank?

      result[:program] = program.to_sym
      assign_attributes(
        name: result[:name],
        program: result[:program],
        attempts: result[:attempts],
        time: result[:splits].map { |split| split.duration }.sum.to_f,
        sum_of_best: result[:splits].map.all? do |split|
          split.best.present?
        end && result[:splits].map do |split|
          split.best
        end.sum.to_f
      )

      populate_category(result[:game], result[:category])
      save if changed?

      @parse_cache = (@parse_cache || {}).merge(fast => result)

      return result
    end
    {}
  end

  def to_param
    id36
  end

  def path
    "/#{to_param}"
  end

  def populate_category(game_string, category_string)
    if category.blank? && game_string.present? && category_string.present?
      game = Game.where("lower(name) = ?", game_string.downcase).first_or_create(name: game_string)
      self.category = game.categories.where("lower(name) = ?", category_string.downcase).first_or_create(name: category_string)
    end
  end

  def refresh_from_file
    game = Game.from_name(parse[:game])
    category = game ? game.categories.from_name(parse[:category]) : nil
    update(category: category, archived: !pb?)
  end

  def file
    run_file.file
  end

  def refresh_game
    return if game.blank?
    game.delay.sync_with_srl
  end

  # If we don't have a user assigned but we do have a speedrun.com run assigned, try to fetch the user from
  # speedrun.com. For this to work that user must have a splits.io account and must have their Twitch account tied to
  # their speedrun.com account.
  def discover_runner
    return if user.present?
    delay.set_runner_from_srdc
  end

  def filename(download_program)
    extension = {'livesplit' => 'lss', 'urn' => 'json'}[download_program] || download_program
    "#{to_param}.#{extension}"
  end

  def set_name
    if [category, game].all? { |i| i.try(:name).present? }
      self.name = "#{category.game.name} #{category.name}"
    end
  end

  def original_file
    program == :llanfair ? RunFile.pack_binary(file) : file
  end
end
