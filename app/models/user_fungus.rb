class UserFungus < ActiveRecord::Base
  belongs_to :game_stage
  attr_accessible :x_y,:game_stage, :x, :y, :status
  attr_accessor :x_y

  LIFE = 0
  DIED = 1

  def before_save
    if self.status.nil?
      self.status = LIFE
    end
    true
  end
#  validates :x_y, user_game_exists_enemy_leukocyte: true
#  validates :x_y, user_game_exists_wall: true
end
