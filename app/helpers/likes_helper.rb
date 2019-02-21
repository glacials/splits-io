module LikesHelper
  MAX_NAMES = 4.freeze

  def tooltip(run)
    count = run.likes.count

    if count <= MAX_NAMES
      return "Liked by #{run.likes.limit(MAX_NAMES).joins(:user).pluck(:name).to_sentence}"
    end

    return "Liked by #{run.likes.limit(MAX_NAMES - 1).joins(:user).pluck(:name).to_sentence} and #{count - (MAX_NAMES - 1)} others"
  end
end
