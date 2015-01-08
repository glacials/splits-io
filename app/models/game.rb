require 'speedrunslive'

class Game < ActiveRecord::Base
  has_many :categories
  has_many :runs, through: :categories

  after_touch :destroy, if: Proc.new { |game| game.categories.count.zero? }

  def self.search(term)
    t = self.arel_table
    where(t[:name].matches("%#{term}%").or(t[:shortname].eq(term))).order(:name)
  end

  def to_param
    shortname || name.downcase.gsub(' ', '+').gsub(/\..*/, '')
  end

  def fetch_srl_info
    return if srl_id.present? && shortname.present?
    game = ::SpeedRunsLive.game(name)
    return if game.nil?

    assign_attributes(srl_id: game['id'].to_i, shortname: game['abbrev'])
  rescue SocketError
  end
end
