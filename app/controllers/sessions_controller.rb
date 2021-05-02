class SessionsController < ApplicationController
  def new
    redirect_to(redirect_path) if current_user.present?
  end

  def create
    @user = User.find_by(email: session_params[:email])
    if @user.nil?
      redirect_back(
        alert: "No account exists with that email address.",
        fallback_location: new_session_path,
      )
      return
    end

    if @user.password_digest.nil?
      if @user.twitch
        redirect_back(
          alert: <<~ALERT,
            Your account exists, but you created it with a Twitch link and
            have not set a password. Please sign in with Twitch then set a
            password from the settings page to enable email/password login.
            (If you do not have access to your Twitch account, use the "I
            forgot my password" feature.)
          ALERT
          fallback_location: new_session_path,
        )
        return
      end

      if @user.google
        redirect_back(
          alert: <<~ALERT,
            Your account exists, but you created it with a Google link and
            have not set a password. Please sign in with Google then set a
            password from the settings page to enable email/password login.'
            (If you do not have access to your Google account, use the "I
            forgot my password" feature.)
          ALERT
          fallback_location: new_session_path,
        )
        return
      end

      redirect_back(
        alert: <<~ALERT,
          Your account exists but has no password set, so cannot be logged
          into. Please use the "I forgot my password" feature to set a
          password.
        ALERT
        fallback_location: new_session_path,
      )
      return
    end

    if @user.authenticate(session_params[:password])
      sign_in(@user)
      redirect_to(
        redirect_path,
        notice: "'Hoy!! Signed in as #{@user.name}.",
      )
      return
    end

    redirect_back(
      alert: "Invalid email or password.",
      fallback_location: new_session_path,
    )
  end

  def in
    head :ok
  end

  def destroy
    auth_session.invalidate!
    redirect_back fallback_location: root_path, notice: "Signed out. (>-.-)>"
  end

  def failure
    redirect_to redirect_path, alert: "Error: #{params[:message]}"
  end

  private

  def sign_in(user)
    create_auth_session(user)
    auth_session.persist!
  end

  def redirect_path
    request.env["omniauth.origin"] || cookies.delete("return_to") || root_path
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
