# Duration is a wrapper around ActiveSupport::Duration with a focus on formatting and dealing with milliseconds.
class Duration
  include Comparable

  def initialize(milliseconds)
    if milliseconds.nil?
      @duration = nil
    end

    @duration = ActiveSupport::Duration.build(milliseconds / 1000.0)
  end

  # format accepts a number of milliseconds and returns a time like "HH:MM:SS". If precise is true, it returns a time
  # like "HH:MM:SS.cc" instead.
  #
  # When sign is :always, the returned value always has a "+" or "-" in front of it. When sign is :never, the
  # returned value never has a sign in front of it. When sign is :negatives, only negative values have a sign
  # (default).
  def format(precise: false, sign: :negatives)
    return '-' if @duration.nil?

    format = ['%02d', ':%02d', ':%02d']
    components = [hours, minutes, seconds]

    if precise
      format << '.%02d'
      components << (milliseconds / 10)
    end

    if sign == :always || (sign == :negatives && negative?)
      format[0] = '%0+2d'
      return Kernel.format(format.join, *components)
    end

    Kernel.format(format.join, *components)
  end

  # format_casual returns a string like "3m 2s". num_units specifies the max number of unit types to display, e.g. a
  # num_units of 3 will show something like "3m 2s 123ms". The units used are biggest-first, starting with the biggest
  # non-zero unit. Numbers are truncated, not rounded.
  #
  # When sign is :always, the returned value always has a "+" or "-" in front of it. When sign is :never, the
  # returned value never has a sign in front of it. When sign is :negatives, only negative values have a sign
  # (default).
  def format_casual(num_units: 2, sign: :negatives)
    return '-' if nil?

    d = {
      h:  hours,
      m:  minutes,
      s:  seconds,
      ms: milliseconds
    }.drop_while { |_, unit| unit.zero? }

    d = {ms: 0} if d.empty?

    d = d.first(num_units).to_h.map { |k, v| "#{v.to_i}#{k}" }.join(' ')
    return "+#{d}" if sign == :always && positive?
    return "-#{d}" if [:always, :negatives].include?(sign) && negative?

    d
  end

  def !=(other)
    !(self == other)
  end

  def <=>(other)
    other = Duration.new(other) if other.is_a?(Numeric)
    return nil unless other.respond_to?(:to_ms)
    return 0 if to_ms.nil? && other.to_ms.nil?

    if to_ms.nil?
      -1
    elsif other.to_ms.nil?
      1
    else
      to_ms <=> other.to_ms
    end
  end

  def +(other)
    return Duration.new(nil) if nil? || other.nil?

    # other can be a number or a Duration
    other = Duration.new(other) if other.is_a?(Numeric)
    Duration.new(to_ms + other.to_ms)
  end

  def -(other)
    return Duration.new(nil) if nil? || other.nil?

    # other can be a number or a Duration
    other = Duration.new(other) if other.is_a?(Numeric)
    Duration.new(to_ms - other.to_ms)
  end

  def /(other)
    return Duration.new(nil) if nil? || other.nil?

    # other can be a number or a Duration
    other = Duration.new(other) if other.is_a?(Numeric)
    Duration.new(to_ms.to_f / other.to_ms)
  end

  def *(other)
    return Duration.new(nil) if nil? || other.nil?

    # other can be a number or a Duration
    other = Duration.new(other) if other.is_a?(Numeric)
    Duration.new(to_ms * other.to_ms)
  end

  def to_i
    to_ms
  end

  def to_s
    to_ms.to_s
  end

  def present?
    !nil?
  end

  def blank?
    nil?
  end

  def nil?
    @duration.nil? || @duration.zero?
  end

  def to_ms
    @duration.in_milliseconds
  end

  def to_sec
    @duration.to_i
  end

  def abs
    Duration.new(to_ms.try(:abs))
  end

  def positive?
    self >= Duration.new(0)
  end

  def negative?
    self < Duration.new(0)
  end

  private

  def hours
    @duration.parts[:hours]
  end

  def minutes
    @duration.parts[:minutes]
  end

  def seconds
    @duration.parts[:seconds].floor
  end

  def milliseconds
    (@duration.parts[:seconds] % 1 * 1000).floor
  end
end
