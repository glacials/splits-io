class TokensController < Doorkeeper::TokensController
  skip_before_action :set_browser_id, :touch_auth_session
end
