class Duration
  def initialize(milliseconds)
    @ms = milliseconds
  end

  # format accepts a number of milliseconds and returns a time like "HH:MM:SS". If precise is true, it returns a time
  # like "HH:MM:SS.cc" instead.
  #
  # When sign is :always, the returned value always has a "+" or "-" in front of it. When sign is :never, the
  # returned value never has a sign in front of it. When sign is :negatives, only negative values have a sign
  # (default).
  def format(precise: false, sign: :negatives)
    return '-' if @ms.nil?

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

  def ==(duration)
    # Normally we'd call Duration#nil? here, but it treats 0 as nil to deal with old durations in the db where 0 means
    # absent. When those are cleaned up, we can change Duration#nil? and this.
    return false if duration == nil || to_ms.nil? || (duration.respond_to?(:to_ms) && duration.to_ms.nil?)
    return false unless duration.respond_to?(:to_ms)

    to_ms == duration.to_ms
  end

  def !=(duration)
    return false if nil? || duration.nil?
    return false unless duration.respond_to?(:to_ms)

    to_ms != duration.to_ms
  end

  def <(duration)
    # Normally we'd call Duration#nil? here, but it treats 0 as nil to deal with old durations in the db where 0 means
    # absent. When those are cleaned up, we can change Duration#nil? and this.
    return false if duration == nil || to_ms.nil? || (duration.respond_to?(:to_ms) && duration.to_ms.nil?)

    # duration can be a Duration or a number of milliseconds
    ms = duration.respond_to?(:to_ms) ? duration.to_ms : duration

    to_ms < ms
  end

  def <=(duration)
    self < duration || self == duration
  end

  def >(duration)
    # Normally we'd call Duration#nil? here, but it treats 0 as nil to deal with old durations in the db where 0 means
    # absent. When those are cleaned up, we can change Duration#nil? and this.
    return false if duration == nil || to_ms.nil? || (duration.respond_to?(:to_ms) && duration.to_ms.nil?)

    # duration can be a Duration or a number of milliseconds
    ms = duration.respond_to?(:to_ms) ? duration.to_ms : duration

    to_ms > ms
  end

  def >=(duration)
    self > duration || self == duration
  end

  def <=>(duration)
    return nil unless duration.respond_to?(:to_ms)

    to_ms <=> duration.to_ms
  end

  def +(duration)
    return Duration.new(nil) if nil? || duration.nil?

    Duration.new(to_ms + duration.to_ms)
  end

  def -(duration)
    return Duration.new(nil) if nil? || duration.nil?

    Duration.new(to_ms - duration.to_ms)
  end

  def /(duration)
    return Duration.new(nil) if nil? || duration.nil?

    # duration can be a number or a Duration
    ms = (duration == duration.to_i) ? duration : duration.to_ms
    Duration.new(to_ms.to_f / ms)
  end

  def *(duration)
    return Duration.new(nil) if nil? || duration.nil?

    # duration can be a number or a Duration
    ms = (duration == duration.to_i) ? duration : duration.to_ms
    Duration.new(to_ms * ms)
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
    @ms.nil? || @ms.zero?
  end

  def to_ms
    @ms
  end

  def to_sec
    @ms / 1000
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
    @ms.abs / 1000 / 60 / 60
  end

  def minutes
    @ms.abs / 1000 / 60 % 60
  end

  def seconds
    @ms.abs / 1000 % 60
  end

  def milliseconds
    @ms.abs % 1000
  end
end
