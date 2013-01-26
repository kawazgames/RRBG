class EnemyLeukocyte < ActiveRecord::Base
  belongs_to :game_stage
  attr_accessible :game_stage, :x, :y
  attr_accessor :x_y
#  validates :x_y, user_game_exists_user_fungus: true
#  validates :x_y, user_game_exists_wall: true
end
