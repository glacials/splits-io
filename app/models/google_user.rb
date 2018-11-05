class GoogleUser < ApplicationRecord
  belongs_to :user

  include AvatarSource

  def self.from_auth(auth, current_user)
    google_user = GoogleUser.find_or_initialize_by(google_id: auth.uid)
    google_user.user = [
      current_user,
      google_user.user,
      User.joins(:twitch).find_by(twitch_users: {email: auth.info.email}),
      User.new(name: auth.info.email.split('@')[0])
    ].compact.first

    unless google_user.user.save
      google_user.user.errors.full_messages.each do |error|
        google_user.errors.add(:user, error)
      end
      return google_user
    end

    google_user.assign_attributes(
      access_token:            auth.credentials.token,
      access_token_expires_at: Time.at(auth.credentials.expires_at).to_datetime,
      name:                    auth.info.name,
      first_name:              auth.info.first_name,
      last_name:               auth.info.last_name,
      email:                   auth.info.email,
      avatar:                  auth.info.image,
      url:                     auth.info.urls.google
    )

    google_user.save
    google_user
  end
end
