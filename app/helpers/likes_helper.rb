module LikesHelper
  MAX_NAMES = 4.freeze

  def tooltip(run)
    count = run.likes.count
    return nil if count.zero?

    likes = run.likes.joins(:user).limit(MAX_NAMES).pluck(:name)

    if count <= MAX_NAMES
      return "Liked by #{likes.to_sentence}"
    end

    # We use one fewer names than MAX_NAMES here because we want to avoid the case where e.g. four likes are displayed
    # as "Alice, Bob, Carol, and 1 other" rather than the "Alice, Bob, Carol, and Dan".
    return "Liked by #{likes[0..(MAX_NAMES - 2)].to_sentence} and #{count - (MAX_NAMES - 1)} others"
  end
end
