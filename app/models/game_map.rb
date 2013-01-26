class GameMap < ActiveRecord::Base
  belongs_to :game_stage
  attr_accessible :type, :x, :y
end
