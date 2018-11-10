module Authenticatable
  private
  
  def sign_in(user)
    self.current_user = user
    auth_session.persist!
  end

  def redirect_path
    request.env['omniauth.origin'] || cookies.delete('return_to') || root_path
  end
end
