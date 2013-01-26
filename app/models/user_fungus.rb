class UserFungus < ActiveRecord::Base
  belongs_to :game_stage
  attr_accessible :x_y,:game_stage, :x, :y
  attr_accessor :x_y

#  validates :x_y, user_game_exists_enemy_leukocyte: true
#  validates :x_y, user_game_exists_wall: true
end
