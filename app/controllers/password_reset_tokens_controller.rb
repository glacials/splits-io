class PasswordResetTokensController < ApplicationController
  before_action :set_user, only: [:create]
  before_action :set_password_reset_token, only: [:show]

  def new
  end

  def create
    password_reset_token = PasswordResetToken.create(user: @user)
    PasswordResetTokenMailer.with(
      base_url: request.base_url,
      password_reset_token: password_reset_token,
    ).create_email.deliver_later
    redirect_back(
      fallback_location: new_session_path,
      notice: <<~NOTICE,
        An email has been sent to your email address. You can safely close
        this window and click the link in that email to continue.
      NOTICE
    )
  end

  private

  def password_reset_token_params
    params.require(:password_reset_token).permit(:email)
  end

  def set_password_reset_token
    @password_reset_token = PasswordResetToken.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_back(
      alert: <<~ALERT,
        Invalid password reset link. Try clicking the link from your email
        again, or requesting another email.
      ALERT
      fallback_location: new_session_path,
    )
  end

  def set_user
    @user = User.find_by(email: password_reset_token_params[:email])
    if @user.nil?
      redirect_back(
        fallback_location: new_password_reset_token_path,
        alert: 'No user exists with that email.',
      )
    end
  rescue ActionController::ParameterMissing
    redirect_back(
      alert: <<~ALERT,
        No email was given. This sounds like a bug! Please let us know about
        it.
      ALERT
      fallback_location: new_password_reset_token_path,
    )
  end
end
