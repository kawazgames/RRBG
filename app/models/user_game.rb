class UserGame < ActiveRecord::Base
  belongs_to :user
  belongs_to :game_stage
  attr_accessible :status, :user, :user_id, :game_stage, :game_stage_id, :score

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
    @score = game_stage.get_score
    UserGame.transaction do
      ug = UserGame.find(self.id, lock: true)
      if ug.score.nil?
        ug.score = 0
      end
      ug.score = ug.score + @score
      ug.save!
      @score = ug.score
    end
    {
      state: responed[game_stage.play_status],
      score: @score,
      game_stage: responed_stage
    }
  end
end
