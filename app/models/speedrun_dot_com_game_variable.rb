class SpeedrunDotComGameVariable < ApplicationRecord
  belongs_to :speedrun_dot_com_game
  belongs_to :speedrun_dot_com_category, optional: true

  has_many :variable_values, class_name: 'SpeedrunDotComGameVariableValue', dependent: :destroy
  has_one  :default_value,   class_name: 'SpeedrunDotComGameVariableValue', dependent: :destroy
end
