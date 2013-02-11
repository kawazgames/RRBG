class GamesController < ApplicationController
  respond_to :json
  def new
    gs = GameStage.create_copy_with_random
    ug = UserGame.create! user: current_user, game_stage: gs, status: 0
    EnemyLeukocyte.create! game_stage: gs, x:6, y:6
    EnemyLeukocyte.create! game_stage: gs, x:4, y:2
    EnemyLeukocyte.create! game_stage: gs, x:1, y:2
    EnemyLeukocyte.create! game_stage: gs, x:8, y:4

    EnemyLeukocyte.create! game_stage: gs, x:8, y:8
    EnemyLeukocyte.create! game_stage: gs, x:4, y:4
    EnemyLeukocyte.create! game_stage: gs, x:5, y:7


    respond_with gs.convert_collection
  end

  def next_turn
    gs = GameStage.find params[:id]
    ug = UserGame.where(game_stage_id: gs.id, user_id: current_user.id).first
    res = ug.next_turn(params[:virus][:position][:y],params[:virus][:position][:x])
    respond_with res, location: nil
  end
end
