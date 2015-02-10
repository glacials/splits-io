class RunValidator < ActiveModel::Validator
  def validate(record)
    validate_video_url(record)
  end

  private

  def validate_video_url(record)
    return if record.video_url.blank?
    URI::parse(record.video_url).tap do |uri|
      unless ['twitch.tv', 'hitbox.tv', 'youtube.com'].include?(uri.host)
        record.errors[:base] << 'Your video URL must be a link to a Twitch, Hitbox, or YouTube video.'
      end
    end
  end
end
