module LandingHelper
  def on_landing_page?
    current_user.nil? && request.fullpath == '/'
  end
end
