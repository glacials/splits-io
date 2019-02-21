class VideoValidator < ActiveModel::Validator
  def validate(record)
    validate_url(record)
  end

  private

  ERROR_MSG = 'Your video URL must be a link to a Twitch or YouTube video.'.freeze

  def validate_url(record)
    record.url.try(:strip!)
    record.errors[:base] << ERROR_MSG unless valid_domain?(record.url)
  rescue URI::InvalidURIError
    record.errors[:base] << ERROR_MSG
  end

  def valid_domain?(url)
    uri = URI.parse(url)
    uri.host.present? && uri.host.match?(/^(www\.)?(twitch\.tv|youtube\.com|youtu\.be)$/)
  end
end
