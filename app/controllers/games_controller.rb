class GamesController < ApplicationController
  respond_to :json
  def new
    gs = GameStage.create_copy_with_random
    ug = UserGame.create! user: current_user, game_stage: gs, status: 0
    uf = UserFungus.create! game_stage: gs, x:1, y:1
    el = EnemyLeukocyte.create! game_stage: gs, x:1, y:2

    respond_with gs.convert_collection
  end

  def next_turn
    ug =  UserGame.where(id: params[:id], user_id: current_user.id).first
    res =  ug.next_turn(params[:virus][:position][:y],params[:virus][:position][:x])
    respond_with res, location: nil
  end
end
