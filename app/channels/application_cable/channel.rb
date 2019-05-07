module ApplicationCable
  class Channel < ActionCable::Channel::Base
    # Allow connection to access ability but not be called from clients
    delegate :ability, to: :connection
    protected :ability
  end
end
