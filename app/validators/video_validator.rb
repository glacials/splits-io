class VideoValidator < ActiveModel::Validator
  def validate(record)
    validate_url(record)
  end

  private

  def validate_url(record)
    record.url.try(:strip!)
    if record.url.blank?
      record.url = nil
      return
    end

    unless record.url[/\Ahttp:\/\//] || record.url[/\Ahttps:\/\//]
      record.url = "https://#{record.url}"
    end

    unless valid_domain?(record.url)
      record.errors[:base] << 'Your video URL must be a link to a Twitch or YouTube video.'
    end

    # Embeds break for URLs like https://www.twitch.tv/videos/29447340?filter=highlights&sort=time, which is what Twitch
    # gives you when you copy the link given by the highlights page for a channel.
    if URI.parse(record.url).host.match?(/^(www\.)?(twitch\.tv)$/)
      record.url = URI(record.url).tap { |u| u.query = nil }.to_s
    end
  rescue URI::InvalidURIError
    record.errors[:base] << 'Your video URL must be a link to a Twitch or YouTube video.'
  end

  def valid_domain?(url)
    uri = URI.parse(url)
    uri.host.present? && uri.host.match?(/^(www\.)?(twitch\.tv|youtube\.com|youtu\.be)$/)
  end
end
