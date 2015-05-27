class RunValidator < ActiveModel::Validator
  def validate(run)
    validate_video_url(run)
  end

  private

  def validate_video_url(run)
    run.video_url = nil if run.video_url.try(:strip) == ''
    return if run.video_url.nil?

    URI.parse(run.video_url).tap do |uri|
      unless uri.host =~ /^(www\.)?(twitch\.tv|hitbox\.tv|youtube\.com)$/
        run.errors[:base] << 'Your video URL must be a link to a Twitch, Hitbox, or YouTube video.'
      end
    end
  end
end
