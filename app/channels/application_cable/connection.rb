module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :onsite

    def connect
      # Identify if the user is 'onsite' so that pre-rendered html can be sent
      self.current_user, self.onsite = find_verified_user
      log_tag = current_user.try(:name) || SecureRandom.hex
      logger.add_tags('ActionCable', log_tag)
    end

    def ability
      # Abilities will become stale if reused when objects are changed, therefore we generate a new one
      # everytime an action needs to be checked
      Ability.new(current_user)
    end

    protected

    def find_verified_user
      onsite = ['splits.io', 'localhost'].include?(request.host)
      passed_token = request.query_parameters[:access_token]
      return [nil, onsite] if passed_token.nil?

      # If a token is explicitly passed in then error out instead of going into anonymous mode if it isn't valid
      access_token = Doorkeeper::AccessToken.by_token(passed_token)
      reject_unauthorized_connection unless access_token
      reject_unauthorized_connection unless access_token.includes_scope?(:websocket_sign_in)

      user = User.find_by(id: access_token.try(:resource_owner_id))
      reject_unauthorized_connection if user.nil?

      [user, onsite]
    end
  end
end
