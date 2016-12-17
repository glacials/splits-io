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

    def program(string_or_symbol)
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
    read_attribute(:program) || parse[:timer]
  end

  def timer
    program
  end

  def dynamo(attr)
    parse(fast: true)[attr.to_sym]
  end

  def parse_into_dynamodb
    timer_used = nil
    parse_result = nil

    Run.programs.each do |timer|
      parse_result = timer::Parser.new.parse(file, fast: true)

      if parse_result.present?
        timer_used = timer.to_sym
        break
      end
    end

    return false if timer_used.nil?

    if game.nil? || category.nil?
      populate_category(parse_result[:game], parse_result[:category])
      save
    end

    splits = parse_result[:splits].map do |split|
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

    run = {
      'id' => id36,
      'timer' => timer_used.to_s,
      'attempts' => parse_result[:attempts],
      'srdc_id' => srdc_id || parse_result[:srdc_id].presence,
      'duration_in_seconds' => parse_result[:splits].map { |split| split.duration }.sum.to_f,
      'sum_of_best' => parse_result[:splits].map.all? do |split|
          split.best.present?
        end && parse_result[:splits].map do |split|
          split.best
        end.sum.to_f,
      'splits' => splits
    }

    $dynamodb_splits.put_item(item: run)
  end

  def fetch_from_dynamodb
    key = {id: id36}
    attrs = 'id, timer, attempts, srdc_id, duration_in_seconds, sum_of_best, splits'

    options = {
      key: key,
      projection_expression: attrs
    }

    resp = $dynamodb_splits.get_item(options)
    resp.item
  end

  def parses?(fast: true, convert: false)
    parse(fast: fast, convert: convert).present?
  end

  def parse(fast: true, convert: false)
    return @parse_cache[fast] if @parse_cache.try(:[], fast).present?
    return @parse_cache[false] if @parse_cache.try(:[], false).present?
    return @convert_cache if @convert_cache.present?

    if fast && !convert
      resp = fetch_from_dynamodb
      if resp.blank?
        parse_into_dynamodb
        resp = fetch_from_dynamodb
      end

      if resp.present?
        update(
          srdc_id: resp['srdc_id'],
          time: resp['duration_in_seconds'],
          sum_of_best: resp['sum_of_best']
        )

        return {
          id: resp['id'],
          timer: resp['timer'],
          attempts: resp['attempts'],
          srdc_id: resp['srdc_id'],
          duration: resp['duration_in_seconds'],
          sum_of_best: resp['sum_of_best'],
          splits: resp['splits'].map do |split|
            s = Split.new
            s.name = split['title']
            s.duration = split['duration_in_seconds'].to_f
            s.finish_time = split['finish_time'].to_f
            s.best = split['best'].to_f
            s.gold = split['gold?']
            s.skipped = split['skipped?']
            s.reduced = split['reduced?']
            s
          end
        }.merge(resp)
      end
    end

    Run.programs.each do |timer|
      parse_result = timer::Parser.new.parse(file, fast: fast)
      next if parse_result.blank?

      parse_result[:timer] = timer.to_sym
      assign_attributes(
        program: parse_result[:timer],
        attempts: parse_result[:attempts],
        srdc_id: srdc_id || parse_result[:srdc_id].presence,
        time: parse_result[:splits].map { |split| split.duration }.sum.to_f,
        sum_of_best: parse_result[:splits].map.all? do |split|
          split.best.present?
        end && parse_result[:splits].map do |split|
          split.best
        end.sum.to_f
      )

      if convert
        @convert_cache = parse_result
      else
        populate_category(parse_result[:game], parse_result[:category])
        save
      end

      @parse_cache = (@parse_cache || {}).merge(fast => parse_result)

      if fast && !convert
        splits = parse_result[:splits].map do |split|
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

        $dynamodb_splits.put_item(
          item: {
            'id' => id36,
            'timer' => parse_result[:timer],
            'attempts' => parse_result[:attempts],
            'srdc_id' => srdc_id || parse_result[:srdc_id].presence,
            'duration_in_seconds' => parse_result[:splits].map { |split| split.duration }.sum.to_f,
            'sum_of_best' => parse_result[:splits].map.all? do |split|
                split.best.present?
              end && parse_result[:splits].map do |split|
                split.best
              end.sum.to_f,
            'splits' => splits
          }
        )
      end
      return parse_result
    end

    {}
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
