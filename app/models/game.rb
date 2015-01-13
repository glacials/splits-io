require 'speedrunslive'

class Game < ActiveRecord::Base
  validates :name, presence: true

  has_many :categories
  has_many :runs, through: :categories

  after_save :sync_with_srl

  after_touch :destroy, if: Proc.new { |game| game.categories.count.zero? }

  def self.search(term)
    t = self.arel_table
    where(t[:name].matches("%#{term}%").or(t[:shortname].eq(term))).order(:name)
  end

  def to_param
    shortname || name.downcase.gsub(' ', '+').gsub(/\..*/, '')
  end

  def sync_with_srl
    return if srl_id.present? && shortname.present?
    game = ::SpeedRunsLive.game(name)
    return if game.nil?

    update_attributes(srl_id: game['id'].to_i, shortname: game['abbrev'])
  end
  handle_asynchronously :sync_with_srl

  def to_s
    name
  end
end
