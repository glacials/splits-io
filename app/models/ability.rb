class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, [Run, Category, Game, User]

    can [:update, :create, :destroy], Run, user_id: user.id
    cannot [:update, :create, :destroy], Run, user_id: nil
    can [:read, :update, :create, :destroy], Rivalry, from_user_id: user.id
    can [:destroy], Doorkeeper::Application, owner_id: user.id

    if user.id == 1
      can [:update, :destroy, :merge], Game
      can [:update, :destroy], Run
    end
  end
end
