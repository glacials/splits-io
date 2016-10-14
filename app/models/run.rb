Dir['./lib/parsers/*'].each { |file| require file }

class Run < ApplicationRecord
  include PadawanRun
  include ForgetfulPersonsRun
  include SRDCRun
  include CompletedRun

  include ActionView::Helpers::DateHelper

  belongs_to :user
  belongs_to :category
  belongs_to :run_file, primary_key: :digest, foreign_key: :run_file_digest
  has_one :game, through: :category

  has_secure_token :claim_token

  after_create -> { parse(fast: true) if run_file.present? }
  after_create :refresh_game
  after_create :discover_runner

  after_destroy :destroy_run_file_if_orphaned

  #validates :run_file, presence: true
  validates_with RunValidator

  before_save :set_name

  scope :by_game, ->(game_or_games) { joins(:category).where(categories: {game_id: game_or_games}) }
  scope :by_category, ->(category) { where(category: category) }
  scope :nonempty, -> { where("time != 0") }
  scope :owned, -> { where.not(user: nil) }
  scope :unarchived, -> { where(archived: false) }
  scope :categorized, -> { joins(:category).where.not(categories: {name: nil}).joins(:game).where.not(games: {name: nil}) }

  class << self
    def programs
      [Llanfair, Urn, LiveSplit, SplitterZ, TimeSplitTracker, WSplit]
    end

    def program(string_or_symbol)
      program_strings = Run.programs.map(&:to_sym).map(&:to_s)
      h = Hash[program_strings.zip(Run.programs)]
      h[string_or_symbol.to_s]
    end

    alias_method :find10, :find
    def find(id)
      find10(id.to_i(36))
    end
  end

  alias_method :id10, :id
  def id
    if id10.is_a? Numeric
      id10.to_s(36)
    else
      nil
    end
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

  def parses?(fast: true, convert: false)
    parse(fast: fast, convert: convert).present?
  end

  def parse(fast: true, convert: false)
    return @parse_cache[fast] if @parse_cache.try(:[], fast).present?
    return @parse_cache[false] if @parse_cache.try(:[], false).present?
    return @convert_cache if @convert_cache.present?

    if fast && !convert
      result = $dynamodb_table.get_item(
        key: {
          id: id
        },
        projection_expression: 'id, title, timer, attempts, srdc_id, duration_in_seconds, sum_of_best, splits'
      )
      if result.item.present?
        return {
          id: result.item['id'],
          title: result.item['title'],
          timer: result.item['timer'],
          attempts: result.item['attempts'],
          srdc_id: result.item['srdc_id'],
          duration: result.item['duration_in_seconds'],
          sum_of_best: result.item['sum_of_best'],
          splits: result.item['splits'].map do |split|
            s = Split.new
            s.name = split['title']
            s.duration = split['duration_in_seconds'].round(2)
            s.finish_time = split['finish_time'].round(2)
            s.best = split['best'].round(2)
            s.gold = split['gold?']
            s.skipped = split['skipped?']
            s.reduced = split['reduced?']
            s
          end
        }.merge(result.item)
      end
    end

    timer = Run.program(program)

    if timer.present?
      timers_to_try = [timer]
    else
      timers_to_try = Run.programs
    end

    timers_to_try.each do |program|
      result = program::Parser.new.parse(file, fast: fast)
      next if result.blank?

      result[:program] = program.to_sym
      assign_attributes(
        name: result[:name],
        program: result[:program],
        attempts: result[:attempts],
        srdc_id: srdc_id || result[:srdc_id].presence,
        time: result[:splits].map { |split| split.duration }.sum.to_f,
        sum_of_best: result[:splits].map.all? do |split|
          split.best.present?
        end && result[:splits].map do |split|
          split.best
        end.sum.to_f
      )

      if convert
        @convert_cache = result
      else
        populate_category(result[:game], result[:category])
        save if changed?
      end

      @parse_cache = (@parse_cache || {}).merge(fast => result)

      if fast && !convert
        splits = result[:splits].map do |split|
          {
            'title' => split.name.presence,
            'duration_in_seconds' => split.duration,
            'finish_time' => split.finish_time,
            'best' => split.best,
            'gold?' => split.gold?,
            'skipped?' => split.skipped?,
            'reduced?' => split.reduced?
          }
        end

        $dynamodb_table.put_item(
          item: {
            'id' => id,
            'title' => result[:name].presence,
            'timer' => result[:program],
            'attempts' => result[:attempts],
            'srdc_id' => srdc_id || result[:srdc_id].presence,
            'duration_in_seconds' => result[:splits].map { |split| split.duration }.sum.to_f,
            'sum_of_best' => result[:splits].map.all? do |split|
                split.best.present?
              end && result[:splits].map do |split|
                split.best
              end.sum.to_f,
            'splits' => splits
          }
        )
      end

      return result
    end

    {}
  end

  def to_param
    id
  end

  def to_s
    name
  end

  def name
    read_attribute(:name).presence || "(no title)"
  end

  def path
    "/#{to_param}"
  end

  CATEGORY_ALIASES = {"Any% (NG+)" => "Any% NG+"}

  def populate_category(game_string, category_string)
    category_string = CATEGORY_ALIASES.fetch(category_string, category_string)

    if category.blank? && game_string.present? && category_string.present?
      game = Game.from_name!(game_string)
      self.category = game.categories.where("lower(name) = lower(?)", category_string).first_or_create(name: category_string)
    end
  end

  def file
    if id.present?
      file = $s3_bucket.object("splits/#{id}")
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

  def filename(program: Run.program(self.program))
    "#{to_param}.#{program.file_extension}"
  end

  def set_name
    if [category, game].all? { |i| i.try(:name).present? }
      self.name = "#{category.game.name} #{category.name}"
    end
  end

  def original_file
    if program.to_sym == :llanfair && file.is_a?(Array)
      RunFile.pack_binary(file)
    else
      file
    end
  end

  def destroy_run_file_if_orphaned
    return if run_file.nil?

    if run_file.runs.where.not(id: id).empty?
      run_file.destroy
    end
  end
end
