class UserGame < ActiveRecord::Base
  belongs_to :user
  belongs_to :game_stage
  attr_accessible :status, :user, :game_stage
end
