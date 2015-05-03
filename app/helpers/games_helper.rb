module GamesHelper
  def placeholder
    random_placeholder || Game.new(name: 'Super Mario Sunshine', shortname: 'sms')
  end

  private

  def random_placeholder
    @random_placeholder ||= Game.where.not(shortname: nil).offset(rand(Game.where.not(shortname: nil).count)).first
  end
end
