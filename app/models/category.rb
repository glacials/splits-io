class Category < ApplicationRecord
  belongs_to :game

  has_many :runs,      dependent: :nullify
  has_many :rivalries, dependent: :destroy
  has_many :races,     dependent: :nullify, class_name: 'Race'

  has_many :run_histories, through: :runs, source: :histories

  has_many :users, through: :runs

  has_one :srdc, class_name: 'SpeedrunDotComCategory', dependent: :destroy

  before_create :autodetect_shortname

  validates :name, presence: true

  scope :nonempty, -> {joins(:runs).distinct}

  def self.global_aliases
    {
      'Any% (NG+)'        => 'Any% NG+',
      'Any% (New Game+)'  => 'Any% NG+',
      'Any %'             => 'Any%',
      'All Skills No OOB' => 'All Skills no OOB no TA' # for ori_de
    }
  end

  def self.from_name(name)
    return nil if name.blank?

    name = name.strip
    find_by('lower(name) = lower(?)', name)
  end

  def self.from_name!(name)
    return nil if name.blank?

    name = name.strip
    where('lower(name) = lower(?)', name).first_or_create(name: name)
  end

  def runners
    User.that_run(self)
  end

  def best_known_run(timing)
    case timing
    when Run::REAL
      runs.unarchived.where.not(realtime_duration_ms: 0).order(realtime_duration_ms: :asc).first
    when Run::GAME
      runs.unarchived.where.not(gametime_duration_ms: 0).order(gametime_duration_ms: :asc).first
    end
  end

  def to_s
    name || 'Untitled category'
  end

  def to_param
    id.to_s
  end

  def autodetect_shortname
    {
      'any%' => 'anypct',
      '100%' => '100pct'
    }[name.try(:downcase)]
  end

  def shortname
    return nil if name.nil?

    name.downcase.gsub(/ *%/, 'pct').gsub(/ +/, '-')
  end

  def popular?
    runs.count * 10 >= game.runs.count
  end

  # merge_into! changes ownership of this category's runs and rivalries to the given category, then destroys this
  # category. Does nothing if the given category is nil.
  def merge_into!(category)
    return if category.nil?

    ApplicationRecord.transaction do
      runs.update_all(category_id: category.id)
      rivalries.update_all(category_id: category.id)
      destroy
    end
  end

  # route returns a run whose route is the most popular in this category, as determined by the number of runs sharing
  # its segment names and order. Returns nil if no runs exist in this category.
  def route
    result = Run.select('MIN(runs.id) as id')
                .joins(:segments)
                .where(category: self)
                .group(:segment_number, :name)
                .order(Arel.sql('COUNT(*) DESC'))
                .first

    return nil if result.nil?

    Run.find(result.id)
  end

  # median_duration returns the median duration of completed attempts for this category. If attempt_number is given, it
  # returns the median duration of completed attempts which had that attempt number.
  def median_duration(timing, attempt_number: nil)
    relation = run_histories.joins(:run).where(
      runs: {archived: false}
    ).where.not(runs: {user: nil}).where.not(Run.duration_type(timing) => nil).where.not(Run.duration_type(timing) => 0).where('runs.created_at > ?', 3.months.ago)

    return Duration.new(relation.median("run_histories.#{Run.duration_type(timing)}")) if attempt_number.nil?

    Duration.new(relation.where(attempt_number: attempt_number).median("run_histories.#{Run.duration_type(timing)}"))
  end
end
