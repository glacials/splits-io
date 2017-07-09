class AuthorizedApplicationsController < Doorkeeper::ApplicationController
  before_action :authenticate_resource_owner!

  def destroy
    Doorkeeper::AccessToken.revoke_all_for(params[:application], current_resource_owner)
    redirect_to settings_path, notice: I18n.t(:notice, scope: [:doorkeeper, :flash, :authorized_applications, :destroy])
  end
end
