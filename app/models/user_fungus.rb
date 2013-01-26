class UserFungus < ActiveRecord::Base
  belongs_to :user_game
  attr_accessible :user_game, :x, :y
end
