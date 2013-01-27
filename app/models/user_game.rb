class UserGame < ActiveRecord::Base
  belongs_to :user
  belongs_to :game_stage
  attr_accessible :status, :user, :user_id, :game_stage, :game_stage_id

  def convert_collection
    map = GameMap.where(user_game_stage: self).all(lock: true)
    {
      id: self.id,
      game_map: map.convert_collection
    }
  end

  def next_turn(fungus_x, fungus_y)
    responed = { GameStage::STATE_PLAYING => "playing", GameStage::STATE_GAMEOVER => "gameover" }
    game_stage = GameStage.where(id: self.game_stage_id).first
    responed_stage = game_stage.set_and_step(fungus_x, fungus_y)
    {
      state: responed[game_stage.play_status],
      score: game_stage.get_score,
      game_stage: responed_stage
    }
  end
end
