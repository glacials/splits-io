class Ability
  include CanCan::Ability

  def initialize(user)
    grant_anon_perms
    grant_user_perms(user) if user
    grant_admin_perms if user.try(:admin?)
  end

  private

  def grant_anon_perms
    can(%i[create read], User)
    can(%i[create read], Game)
    can(%i[create read], Category)
    can(%i[create read], Run)
  end

  def grant_user_perms(user)
    can(%i[create read update destroy], Run,                     user_id:      user.id)
    can(%i[create read update destroy], Rivalry,                 from_user_id: user.id)
    can(%i[create read update destroy], Doorkeeper::Application, owner_id:     user.id)
    can(%i[create read update destroy], RunLike,                 user_id:      user.id)
    can(%i[create read update destroy], SpeedrunDotComUser,      user_id:      user.id)

    cannot(%i[update destroy], Run, user_id: nil)
  end

  def grant_admin_perms
    can(%i[create read update destroy],       User)
    can(%i[create read update destroy merge], Game)
    can(%i[create read update destroy merge], Category)
    can(%i[create read update destroy],       Rivalry)
    can(%i[create read update destroy],       Doorkeeper::Application)
  end
end
