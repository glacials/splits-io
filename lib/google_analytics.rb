class GoogleAnalytics
  @tracker = Staccato.tracker("UA-2876079-8", "rails-#{Rails.env}", ssl: true)

  def self.track_event(category:, action:)
    @tracker.event(
      category: category,
      action: action,
    )
  end
end
