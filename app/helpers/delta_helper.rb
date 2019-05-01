module DeltaHelper
  include ActionView::Helpers::DateHelper

  # delta returns a green or red difference between the given base Duration or Fixnum and compare Duration or Fixnum,
  # with an upwards- or downwards-pointing arrow to signify the direction. No sign is attached, even if the number is
  # negative.
  #
  # If better is :lower (default), the value will be colored green if base is lower than compare.
  # If better is :higher, it will be colored green if base is higher than compare.
  # If better is :different, it will be colored green if different from compare.
  #
  # Pass a subject string to fill in the tooltip like so: "Compared to #{subject}".
  def delta(base, compare, subject:, better: :lower)
    classes = %w[delta-indicator tip-top mx-2 cursor-default]

    if base == compare
      classes << 'text-muted'
      text = 'tied'
    else
      text = (base - compare).abs
      # Format if they're Durations, leave alone if they're flat numbers (e.g. # attempts)
      text = text.format_casual if [base, compare].all? { |d| d.respond_to?(:format_casual) }
    end

    if base < compare
      classes << 'delta-negative'
    elsif base > compare
      classes << 'delta-positive'
    end

    if (better == :higher && base > compare) || (better == :lower && base < compare) || (better == :different && base != compare)
      classes << 'text-success'
    else
      classes << 'text-danger'
    end

    tag.small(text, class: classes, title: "Compared to #{subject}")
  end
end
