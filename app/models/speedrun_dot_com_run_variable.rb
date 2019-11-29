class SpeedrunDotComRunVariable < ApplicationRecord
  belongs_to :run
  belongs_to :speedrun_dot_com_game_variable_value
end
