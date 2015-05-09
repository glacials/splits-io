class RunValidator < ActiveModel::Validator
  def validate(record)
    validate_video_url(record)
  end

  private

  def validate_video_url(record)
    record.video_url = nil if record.video_url.try(:strip) == ''
    return if record.video_url.nil?

    URI.parse(record.video_url).tap do |uri|
      unless uri.host =~ /^(www\.)?(twitch\.tv|hitbox\.tv|youtube\.com)$/
        record.errors[:base] << 'Your video URL must be a link to a Twitch, Hitbox, or YouTube video.'
      end
    end
  end
end
