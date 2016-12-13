class GoogleController < ApplicationController
  def in
    resp = request.env['omniauth.auth']

    google_user = {
      'user_id' => current_user.id.to_s,
      'credentials' => resp.credentials,

      'google_id' => resp.uid,
      'google_email' => resp.info.email,

      'created_at' => Time.now.to_i,
      'updated_at' => Time.now.to_i
    }

    $dynamodb_google_users.put_item(item: google_user)

    redirect_to(
      settings_path,
      notice: "Linked with Google! You can now export raw run data to Google Sheets from run stats pages."
    )
  end

  def unlink
    $dynamodb_google_users.delete_item(
      key: {
        user_id: current_user.id.to_s
      }
    )

    redirect_to settings_path, notice: "Google account unlinked :]"
  end

  def failure
    redirect_to redirect_path, alert: "Error: #{params[:message]}"
  end
end
