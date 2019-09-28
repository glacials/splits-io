require 'active_support/concern'

module Subsplit
  extend ActiveSupport::Concern

  def subsplit?
    return false unless name.present?
    /^[-\{]/.match?(name)
  end

  def last_subsplit?
    /^\{/.match?(name)
  end

  def display_name
    return name unless subsplit?
    /^(?:-|\{.*?}\s*)(.+)/.match(name)[1]
  end
end
