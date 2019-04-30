class Duration
  def initialize(milliseconds)
    @ms = milliseconds
  end

  # format accepts a number of milliseconds and returns a time like "HH:MM:SS". If precise is true, it returns a time
  # like "HH:MM:SS.cc" instead.
  def format(precise: false)
    return '-' if @ms.nil?

    return Kernel.format('%02d:%02d:%02d.%02d', hours, minutes, seconds, milliseconds) if precise
    Kernel.format('%02d:%02d:%02d', hours, minutes, seconds)
  end

  # format_casual returns a string like "3m 2s". num_units specifies the max number of unit types to display, e.g. a
  # num_units of 3 will show something like "3m 2s 123ms". The units used are biggest-first, starting with the biggest
  # non-zero unit. Numbers are truncated, not rounded.
  #
  # When signed is true, the returned value always has a "+" or "-" in front of it. When signed is false, only negative
  # values have a sign.
  def format_casual(num_units: 2, signed: false)
    return '-' if @ms.nil? || @ms.zero?

    d = {
      h:  hours,
      m:  minutes,
      s:  seconds,
      ms: milliseconds
    }.drop_while { |_, unit| unit.zero? }

    d = d.first(num_units).to_h.map { |k, v| "#{v.to_i}#{k}" }.join(' ')
    d = "+#{d}" if @ms.positive? && signed
    d
  end

  def ==(duration)
    return false unless duration.respond_to?(:to_ms)
    to_ms == duration.to_ms
  end

  def <(duration)
    return false if [to_ms, duration.to_ms].include?(0)

    to_ms < duration.to_ms
  end

  def >(duration)
    return false if [to_ms, duration.to_ms].include?(0)

    to_ms > duration.to_ms
  end

  def <=>(duration)
    return nil unless duration.respond_to?(:to_ms)

    to_ms <=> duration.to_ms
  end

  def -(duration)
    Duration.new(to_ms - duration.to_ms)
  end

  def /(duration)
    # duration can be a number or a Duration
    ms = (duration == duration.to_i) ? duration : duration.to_ms
    Duration.new(to_ms.to_f / ms)
  end

  def *(duration)
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
    @ms == nil
  end

  def to_ms
    @ms
  end

  private

  def hours
    # This method and the below ones behave differently when @ms is negative because in integer division and modulo,
    # operations like 100/60 or 100%60 are widly different from (-100)/60 or (-100)%60; i.e. the answers aren't
    # negatives of each other.
    return -(@ms.abs / 1000 / 60 / 60) if @ms < 0

    @ms / 1000 / 60 / 60
  end

  def minutes
    return -(@ms.abs / 1000 / 60 % 60) if @ms < 0

    @ms / 1000 / 60 % 60
  end

  def seconds
    return -(@ms.abs / 1000 % 60) if @ms < 0

    @ms / 1000 % 60
  end

  def milliseconds
    return -(@ms.abs % 1000) if @ms < 0

    @ms % 1000
  end
end
