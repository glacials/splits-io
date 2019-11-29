class SpeedrunDotComGameVariableValue < ApplicationRecord
  belongs_to :speedrun_dot_com_game_variable

  has_many :run_variables, class_name: 'SpeedrunDotComRunVariable', dependent: :destroy
end
