class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    grant_anon_perms
    grant_user_perms(user)
    grant_admin_perms if user.id == 1
  end

  private

  def grant_anon_perms
    can(%i[create read], Run)
    can(%i[create read], Category)
    can(%i[create read], Game)
    can(%i[create read], User)
  end

  def grant_user_perms(user)
    can(%i[create read update destroy], Run,                     user_id:      user.id)
    can(%i[create read update destroy], Rivalry,                 from_user_id: user.id)
    can(%i[create read update destroy], Doorkeeper::Application, owner_id:     user.id)

    cannot(%i[create update destroy], Run, user_id: nil)
  end

  def grant_admin_perms
    can(%i[update destroy merge], Game)
    can(%i[update destroy],       Run)
  end
end
