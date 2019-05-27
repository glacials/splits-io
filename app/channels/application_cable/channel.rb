module ApplicationCable
  class Channel < ActionCable::Channel::Base
    delegate :oauth_token, :oauth_token=, to: :connection
    protected :oauth_token, :oauth_token=
  end
end
