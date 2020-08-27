class UsersController < ApplicationController
  before_action :downcase, only: [:show]
  before_action :set_user, only: [:show, :update]
  before_action :set_password_reset_token, only: [:update]

  def create
    @user = User.create(user_params)
    if !@user.persisted?
      redirect_back(fallback_location: root_path, alert: "Error: #{@user.errors.full_messages.to_sentence}")
      return
    end

    sign_in(@user)
    redirect_back(fallback_location: settings_path, notice: 'Welcome to Splits.io!')
  end

  def show
  end

  def update
    if user_params.reject { |k, v| v.blank? || k == 'password_confirmation' }.empty?
      redirect_back(fallback_location: root_path, alert: 'Nothing was changed.')
      return
    end

    if !@user.update(user_params)
      redirect_back(
        alert: "Error: #{@user.errors.full_messages.to_sentence}.",
        fallback_location: new_password_reset_token_path,
      )
      return
    end

    @password_reset_token.destroy

    sign_in(@user)

    redirect_to(root_path, notice: "Password changed! You are now signed in as #{@user}.")
  end

  private

  def sign_in(user)
    create_auth_session(user)
    auth_session.persist!
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def set_user
    @user = User.find_by(name: params[:id]) || not_found
  end

  def set_password_reset_token
    @password_reset_token = PasswordResetToken.find(params[:user][:password_reset_token][:id])

    if params[:user][:password_reset_token][:token] != @password_reset_token.token
      redirect_back(
        alert: <<~ALERT,
          Invalid password reset link. Try clicking the link from your email
          again, or requesting another email.
        ALERT
        fallback_location: new_password_reset_token_path,
        )
    end

    if @password_reset_token.created_at < Time.now.utc - 2.days
      redirect_back(
        alert: <<~ALERT,
          That password reset link has expired. Password reset links last 48
          hours. Please request another link.
        ALERT
        fallback_location: new_password_reset_token_path,
      )
    end

  rescue ActiveRecord::RecordNotFound
    redirect_back(
      alert: <<~ALERT,
        Invalid password reset link. Try clicking the link from your email
        again, or requesting another email.
      ALERT
      fallback_location: new_password_reset_token_path,
    )
  end

  def downcase
    if params[:id] != params[:id].downcase
      redirect_to user_path(params[:id].downcase)
    end
  end
end
