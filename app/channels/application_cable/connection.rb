module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :onsite

    def connect
      # Identify if the user is 'onsite' so that pre-rendered html can be sent
      self.current_user, self.onsite = find_verified_user
      log_tag = current_user.try(:name) || SecureRandom.uuid
      logger.add_tags('ActionCable', log_tag)
    end

    def oauth_token
      @oauth_token
    end

    def oauth_token=(token)
      @oauth_token = token
    end

    protected

    def find_verified_user
      onsite = ['splits.io', 'localhost'].include?(request.domain(1))
      passed_token = request.query_parameters[:access_token]
      return [nil, onsite] if passed_token.nil?

      # If a token is explicitly passed in then error out instead of going into anonymous mode if it isn't valid
      access_token = Doorkeeper::AccessToken.by_token(passed_token)
      reject_unauthorized_connection unless access_token
      reject_unauthorized_connection if access_token.expired? || !access_token.includes_scope?(:manage_race)

      user = User.find_by(id: access_token.try(:resource_owner_id))
      reject_unauthorized_connection if user.nil?

      self.oauth_token = access_token
      [user, onsite]
    end
  end
end
