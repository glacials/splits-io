class PasswordResetToken < ApplicationRecord
  has_secure_token
  belongs_to :user

  def email
    user&.email
  end
end
