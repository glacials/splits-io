module ApplicationHelper
  def site_title
    ENV['SITE_TITLE'] || 'Splits.io'
  end

  def order_runs(runs)
    dir = %w[asc desc].include?(params[:order]) ? params[:order] : 'desc'
    runs.includes(:video).order(by(params[:by]) => dir)
  end

  def on_a_profile_page?
    current_user.present? && [user_path(current_user), settings_path, tools_path].include?(request.path)
  end

  # user_badge returns a stylized user link in the following priority (high to low):
  #
  # - Override color if override is not nil (gold, silver, standard)
  # - Red if admin
  # - Gold if $4+ patron
  # - Silver if $2+ patron
  # - Standard
  def user_badge(user, override: nil)
    raise "Invalid badge override" if ![nil, :standard, :silver, :gold].include?(override)
    return '???' if user.nil?

    badge = 'badge-dark'
    title = nil

    if override.present?
      badge = 'badge-dark' if override == :standard

      if override == :gold
        badge = 'badge-warning'
        title = "#{user} is a Splits.io patron!"
      end

      if override == :silver
        badge = 'badge-secondary'
        title = "#{user} is a Splits.io patron!"
      end

      return link_to(user, user_path(user), class: ['badge', badge, ('tip-top' if title.present?)], title: title, 'v-tippy' => true, ':title' => "'#{title}'")
    end

    if user.patron?
      badge = 'badge-secondary'
      title = "#{user} is a Splits.io patron!"
    end

    if user.patron?(tier: 2)
      badge = 'badge-warning'
      title = "#{user} is a Splits.io patron!"
    end

    if user.admin?
      badge = 'badge-danger'
      title = "#{user} is a Splits.io staff member!"
    end

    link_to(user, user_path(user), class: ['badge', badge, ('tip-top' if title.present?)], title: title, 'v-tippy' => true, ':title' => "'#{title}'")
  end

  def game_badge(game)
    return '???' if game.nil?

    link_to(game.srdc.try(:shortname), game_path(game), class: 'badge badge-primary', title: game.name)
  end

  # patreon_url returns the URL for the Splits.io Patreon page. If checkout is true, it returns the URL for the
  # checkout page -- use this if the UX of your situation implies the user already decided to contribute. If checkout is
  # :bronze, :silver, or :gold, it returns the URL for the checkout flow for the corresponding tier (i.e. one click past
  # a checkout of true; two clicks past the Splits.io Patreon page).
  def patreon_url(checkout: false)
    return 'https://www.patreon.com/join/glacials/checkout?rid=493467' if checkout == :bronze
    return 'https://www.patreon.com/join/glacials/checkout?rid=493468' if checkout == :silver
    return 'https://www.patreon.com/join/glacials/checkout?rid=493469' if checkout == :gold

    return 'https://www.patreon.com/join/glacials' if checkout

    'https://www.patreon.com/glacials'
  end

  private

  def by(param)
    {
      'created_at' => :created_at,
      'time'       => :realtime_duration_ms,
      'user_id'    => :user_id,
      'video_url'  => :"videos.url"
    }[param] || :created_at
  end
end
