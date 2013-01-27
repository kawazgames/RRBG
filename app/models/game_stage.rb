class GameStage < ActiveRecord::Base

  def self.create_copy_with_random
    size = Stage.count
    if size > 1
      id = Random.new.rand 1..size
    else
      id = 1
    end
    self.create_copy id
  end

  def self.create_copy id
    self.transaction do
      @res = self.create!
      Map.where(stage_id: id).all.each do |e|
        GameMap.create!(game_stage: @res, x: e.x, y: e.y, type: e.type)
      end
    end
    @res
  end
  def convert_collection
    map = GameMap.where(game_stage_id: self.id).all(lock: true)
    {
      id: self.id,
      game_map: map.map{ |m| m.convert_collection }
    }
  end
end
