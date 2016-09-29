class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, [Run, Category, Game, User]

    can [:update, :create, :destroy], Run.owned, user_id: user.id
    can [:read, :update, :create, :destroy], Rivalry, from_user_id: user.id

    if user.name == 'glacials'
      can [:update, :destroy, :merge], Game
      can [:update], Run
    end
  end
end
