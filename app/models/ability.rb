class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    if user.name == 'glacials'
      can :edit, Game
    end
  end
end
