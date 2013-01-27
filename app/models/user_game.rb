class UserGame < ActiveRecord::Base
  belongs_to :user
  belongs_to :game_stage
  attr_accessible :status, :user, :game_stage, :game_stage_id
  def convert_collection
    map = GameMap.where(user_game_stage: self).all(lock: true)
    {
      id: self.id,
      game_map: map.convert_collection
    }
  end

  def next_turn(fungus_x, fungus_y)
    game_stage = GameStage.where(id: self.game_stage_id).first.set_and_step(fungus_x, fungus_y)
    {
      state: "playing",
      game_stage: game_stage
    }
  end
end
