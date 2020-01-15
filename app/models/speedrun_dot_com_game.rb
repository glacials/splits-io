class SpeedrunDotComGame < ApplicationRecord
  belongs_to :game

  has_many :speedrun_dot_com_game_platforms, dependent: :destroy
  has_many :platforms, through: :speedrun_dot_com_game_platforms, source: :speedrun_dot_com_platform
  has_many :speedrun_dot_com_game_regions, dependent: :destroy
  has_many :regions, through: :speedrun_dot_com_game_regions, source: :speedrun_dot_com_region
  has_many :variables, class_name: 'SpeedrunDotComGameVariable', dependent: :destroy
end
