Dir['./lib/programs/*'].each { |file| require file }

class Run < ApplicationRecord
  include CompletedRun
  include ForgetfulPersonsRun
  include PadawanRun
  include S3Run
  include SpeedrunDotComRun
  include UnparsedRun

  include ActionView::Helpers::DateHelper

  # Timing types
  REAL = 'real'.freeze
  GAME = 'game'.freeze

  ALLOWED_PROGRAM_METHODS = %i[to_s to_sym file_extension website content_type].freeze

  belongs_to :user, optional: true
  belongs_to :category, optional: true
  has_one :game, through: :category
  has_many :segments, -> { order(segment_number: :asc) }, dependent: :destroy, inverse_of: :run

  # dependent: :delete_all requires there be no child records that need to be deleted
  # If RunHistory is changed to have child records, change this back to just :destroy
  has_many :histories,            dependent: :delete_all, class_name: 'RunHistory'
  has_one  :highlight_suggestion, dependent: :destroy
  has_many :likes,                dependent: :destroy,    class_name: 'RunLike'
  has_one  :entry,                dependent: :nullify
  has_one  :video,                dependent: :destroy

  has_many :variables,  class_name: 'SpeedrunDotComRunVariable', dependent: :destroy
  belongs_to :platform, class_name: 'SpeedrunDotComPlatform', foreign_key: 'speedrun_dot_com_platform_id', optional: true
  belongs_to :region,   class_name: 'SpeedrunDotComRegion',   foreign_key: 'speedrun_dot_com_region_id',   optional: true

  has_secure_token :claim_token

  validates_with RunValidator

  scope :by_game, ->(game_or_games) { joins(:category).where(categories: {game_id: game_or_games}) }
  scope :by_category, ->(category) { where(category: category) }
  scope :nonempty, -> { where.not(realtime_duration_ms: 0) }
  scope :owned, -> { where.not(user: nil) }
  scope :unarchived, -> { where(archived: false).where.not(user: nil) }
  scope :categorized, lambda {
    joins(:category).where.not(categories: {name: nil}).joins(:game).where.not(games: {name: nil})
  }

  class << self
    def programs
      Programs.constants.map { |c| Programs.const_get(c) }
    end

    def exportable_programs
      Run.programs.select(&:exportable?)
    end

    def exchangeable_programs
      Run.programs.select(&:exchangeable?)
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

    # duration_type is a timing helper for use in queries. e.g. Run.where.not(duration_type(timing) => 0)
    def duration_type(timing)
      case timing
      when REAL
        :realtime_duration_ms
      when GAME
        :gametime_duration_ms
      else
        Rollbar.error("Invalid timing #{timing}")
        :realtime_duration_ms
      end
    end

    # Return a random run. As a special case for development setups, if no runs exist a fake run with a fake ID is
    # returned.
    def random
      Run.offset(rand(Run.count)).first || Run.new(id: 0)
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

  # If we don't have a user assigned but we do have a speedrun.com run assigned, try to
  # fetch the user from speedrun.com. For this to work the run must be finished parsing
  # and that user must have their Twitch account tied to both Splits.io and
  # speedrun.com.
  def discover_runner
    return if user.present?

    DiscoverRunnerJob.perform_later(self)
  end

  def filename(timer: Run.program(self.timer))
    "#{to_param || "#{game} #{category}"}.#{timer.file_extension}"
  end

  def previous_pb(timing)
    return if user.nil?

    case timing
    when Run::REAL
      user.runs.where(
        category: category
      ).where('realtime_duration_ms > ?', duration_ms(timing)).order(realtime_duration_ms: :asc).first
    when Run::GAME
      user.runs.where(
        category: category
      ).where('gametime_duration_ms > ?', duration_ms(timing)).order(gametime_duration_ms: :asc).first
    end
  end

  def pb_date
    histories.where.not(started_at: nil).where.not(ended_at: nil).find_by(
      realtime_duration_ms: duration(Run::REAL).to_ms,
      gametime_duration_ms: duration(Run::GAME).to_ms
    )&.ended_at
  end

  def segment_groups
    segments_with_groups.select(&:segment_group_parent?).map do |segment|
      {
        id:             segment.id,
        display_name:   segment.display_name,
        name:           segment.display_name,
        segment_number: segment.segment_number,
        histories:      segment.segment_group_durations
      }
    end
  end

  # Calculate the various statistical information about each segments history once in the database for the whole run
  # instead of individually for each segment (N queries)
  def segment_history_stats(timing)
    stats = SegmentHistory.joins(segment: :run)
                          .without_statistically_invalid_histories_for_run(self, timing)
                          .where(segment: {runs: {id: id}})
                          .where.not(Run.duration_type(timing) => [0, nil])
                          .where('segments_segment_histories.segment_number = 0 OR (other_histories.attempt_number = segment_histories.attempt_number AND other_histories.segment_number = segments_segment_histories.segment_number - 1)')
                          .group(:segment_id)
                          .select(stats_select_query(timing))

    h = {}
    stats.each do |stat|
      h[stat.segment_id] = {
        standard_deviation: stat.standard_deviation,
        mean:               stat.mean,
        median:             stat.median,
        percentiles:        {
          10 => stat.percentile10,
          90 => stat.percentile90,
          99 => stat.percentile99
        }
      }
    end

    h
  end

  def recommended_comparison(timing)
    query = Run.joins(:video).where(category: category).where.not(user: nil).where.not(category: nil)

    case timing
    when Run::REAL
      query = query.where('realtime_duration_ms < ?', duration(timing).to_ms)
      duration_col = :realtime_duration_ms
    when Run::GAME
      query = query.where('gametime_duration_ms < ?', duration(timing).to_ms)
      duration_col = :gametime_duration_ms
    end

    query.order("videos.url": :asc, duration_col => :desc).first
  end

  def possible_timesave(timing)
    duration(timing) - sum_of_best(timing)
  end

  def segments_with_groups
    return @segments_with_groups if @segments_with_groups

    @segments_with_groups = []
    segment_group_start_index = nil
    segment_group_end_index = nil
    segment_array = segments.with_attached_icon.includes(:histories).order(segment_number: :asc).to_a
    segment_array.each_with_index do |segment, i|
      if !segment_group_start_index && segment.subsplit?
        segment_group_start_index = i
        segment_group_end_index = (segment_array[i..-1].index(&:last_subsplit?) || 0) + i
        @segments_with_groups << SegmentGroup.new(self, segment_array[segment_group_start_index..segment_group_end_index]) unless segment_group_start_index == segment_group_end_index
      end
      if segment_group_end_index == i
        segment_group_start_index = nil
        segment_group_end_index = nil
      end

      @segments_with_groups << segment
    end
    @segments_with_groups
  end

  # split tries to split this run by filling in the first unfilled segment with a time. If more is true and this split
  # would cause the run to complete, a new segment will be created at the end of the run and left blank for the next
  # split to fill. This can be used to perform blind runs where the runner doesn't know how many splits there will be.
  # Just make sure to eventually call this with more=false in order to actually finish the run.
  def split(more: false, realtime_end_ms: nil, gametime_end_ms: nil) # rubocop:todo Metrics/AbcSize Metrics/CyclomaticComplexity Metrics/MethodLength
    prev_segment = segments.order(segment_number: :asc).where(realtime_end_ms: nil).first
    if prev_segment.nil? && more
      prev_segment = segments.order(segment_number: :asc).last
    end

    next_segment = segments.find_by(segment_number: prev_segment.segment_number + 1) if prev_segment

    # Normal split
    if !more || next_segment
      if !prev_segment
        errors.add(:segments, :full, message: 'are all completed; pass more=1 to add one and split')
        return
      end

      if realtime_end_ms
        prev_segment.assign_attributes(
          realtime_end_ms: realtime_end_ms,
          realtime_duration_ms: realtime_end_ms - prev_segment.start(Run::REAL).to_ms,
          realtime_gold: prev_segment.histories.where('realtime_duration_ms < ?', realtime_end_ms - prev_segment.start(Run::REAL).to_ms).none?,
        )
      end

      if gametime_end_ms
        prev_segment.assign_attributes(
          gametime_end_ms: gametime_end_ms,
          gametime_duration_ms: gametime_end_ms - prev_segment.start(Run::GAME).to_ms,
          gametime_gold: prev_segment.histories.where('gametime_duration_ms < ?', gametime_end_ms - prev_segment.start(Run::GAME).to_ms).none?,
        )
      end

      prev_segment.save

      prev_segment_history = prev_segment.histories.new(
        attempt_number: attempts + 1,
      )

      if realtime_end_ms
        prev_segment_history.assign_attributes(
          realtime_duration_ms: realtime_end_ms - prev_segment.start(Run::REAL).to_ms,
        )
      end

      if gametime_end_ms
        prev_segment_history.assign_attributes(
          gametime_duration_ms: gametime_end_ms - prev_segment.start(Run::GAME).to_ms,
        )
      end

      prev_segment_history.save

      # segment could be nil if we just finished the run.
      if next_segment
        next_segment.update(
          realtime_start_ms: realtime_end_ms,
          gametime_start_ms: gametime_end_ms,
        )
      else
        update(
          attempts: attempts + 1,
          realtime_duration_ms: realtime_end_ms,
          gametime_duration_ms: gametime_end_ms,
        )
        histories.create(
          attempt_number: attempts,
          realtime_duration_ms: realtime_end_ms,
          gametime_duration_ms: gametime_end_ms,
        )
      end

      return
    end

    # Smart split, making new segments if none are left

    # If the run was empty
    if !prev_segment
      prev_segment = segments.create(
        segment_number:       0,
        name:                 'Segment 1',
        realtime_start_ms:    0,
        realtime_end_ms:      realtime_end_ms,
        realtime_duration_ms: realtime_end_ms,
        realtime_gold:        true,
        gametime_start_ms:    0,
        gametime_end_ms:      gametime_end_ms,
        gametime_duration_ms: gametime_end_ms,
        gametime_gold:        true,
      )

      prev_segment.histories.create(
        attempt_number:       1,
        realtime_duration_ms: realtime_end_ms,
        gametime_duration_ms: gametime_end_ms,
      )
    end

    if realtime_end_ms
      prev_segment.assign_attributes(
        realtime_end_ms: realtime_end_ms,
        realtime_duration_ms: realtime_end_ms - prev_segment.start(Run::REAL).to_ms,
        realtime_gold: prev_segment.histories.where('realtime_duration_ms < ?', realtime_end_ms - prev_segment.start(Run::REAL).to_ms).none?,
      )
    end

    if gametime_end_ms
      prev_segment.assign_attributes(
        gametime_end_ms: gametime_end_ms,
        gametime_duration_ms: gametime_end_ms - prev_segment.start(Run::GAME).to_ms,
        gametime_gold: prev_segment.histories.where('gametime_duration_ms < ?', gametime_end_ms - prev_segment.start(Run::GAME).to_ms).none?,
      )
    end

    prev_segment.save

    prev_segment_history = prev_segment.histories.build(
      attempt_number: attempts + 1,
    )

    if realtime_end_ms
      prev_segment_history.assign_attributes(
        realtime_duration_ms: realtime_end_ms - prev_segment.start(Run::REAL).to_ms,
      )
    end

    if gametime_end_ms
      prev_segment_history.assign_attributes(
        gametime_duration_ms: gametime_end_ms - prev_segment.start(Run::GAME).to_ms,
      )
    end

    prev_segment_history.save

    next_segment = segments.create(
      segment_number: prev_segment.segment_number + 1,
      name: "Segment #{prev_segment.segment_number + 2}",
      realtime_start_ms: prev_segment.end(Run::REAL).to_ms,
      gametime_start_ms: prev_segment.end(Run::GAME).to_ms,
    )

    $s3_bucket_internal.put_object(
      key: "splits/#{s3_filename}",
      body: ApplicationController.new.render_to_string(
        template: 'runs/exports/exchange',
        layout: false,
        locals: {:@run => self},
      ),
    )

    save
  end

  def in_progress?(timing)
    !completed?(timing)
  end

  def completed?(timing)
    duration(timing).present? && duration(timing).positive?
  end

  private

  def stats_select_query(timing)
    case timing
    when Run::REAL
      'segment_id,
      STDDEV_POP(segment_histories.realtime_duration_ms) AS standard_deviation,
      AVG(segment_histories.realtime_duration_ms) AS mean,
      PERCENTILE_DISC(.5) WITHIN GROUP (ORDER BY segment_histories.realtime_duration_ms) AS median,
      PERCENTILE_CONT(.1) WITHIN GROUP (ORDER BY segment_histories.realtime_duration_ms) AS percentile10,
      PERCENTILE_CONT(.9) WITHIN GROUP (ORDER BY segment_histories.realtime_duration_ms) AS percentile90,
      PERCENTILE_CONT(.99) WITHIN GROUP (ORDER BY segment_histories.realtime_duration_ms) AS percentile99
      '.squish
    when Run::GAME
      'segment_id,
      STDDEV_POP(segment_histories.gametime_duration_ms) AS standard_deviation,
      AVG(segment_histories.gametime_duration_ms) AS mean,
      PERCENTILE_DISC(.5) WITHIN GROUP (ORDER BY segment_histories.gametime_duration_ms) AS median,
      PERCENTILE_CONT(.1) WITHIN GROUP (ORDER BY segment_histories.gametime_duration_ms) AS percentile10,
      PERCENTILE_CONT(.9) WITHIN GROUP (ORDER BY segment_histories.gametime_duration_ms) AS percentile90,
      PERCENTILE_CONT(.99) WITHIN GROUP (ORDER BY segment_histories.gametime_duration_ms) AS percentile99
      '.squish
    else
      raise 'Unsupported timing'
    end
  end
end
