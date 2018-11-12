module ApplicationHelper
  def site_title
    ENV['SITE_TITLE'] || 'Splits I/O'
  end

  def order_runs(runs)
    dir = %w[asc desc].include?(params[:order]) ? params[:order] : 'desc'
    runs.order(by(params[:by]) => dir)
  end

  def on_a_profile_page?
    current_user.present? && [user_path(current_user), settings_path, tools_path].include?(request.path)
  end

  # user_badge returns a stylized user link, with the gold patron border if the user is the right level of patron. If
  # gold is true, a gold style is forced; if false, a non-gold style is forced; if nil, the user's patron status is
  # checked and applied appropriately.
  def user_badge(user, gold: nil)
    return '???' if user.nil?

    classes = ['badge']
    title = nil
    if gold || (gold.nil? && user.silver_patron?)
      classes << 'badge-warning'
      classes << 'tip-top'
      title = "#{user} is a Splits I/O Patron!"
    else
      classes << 'badge-secondary'
    end

    link_to(user, user_path(user), class: classes.join(' '), title: title)
  end

  def game_badge(game)
    return '???' if game.nil?

    link_to(game.shortname, game_path(game), class: 'badge badge-primary', title: game.name)
  end

  # patreon_url returns the URL for the Splits I/O Patreon page. If checkout is true, it returns the URL for the
  # checkout page -- use this if the UX of your situation implies the user already decided to contribute. If checkout is
  # :bronze, :silver, or :gold, it returns the URL for the checkout flow for the corresponding tier (i.e. one click past
  # a checkout of true; two clicks past the Splits I/O Patreon page).
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
      'user_id'    => :user_id
    }[param] || :created_at
  end
end
