class GameMap < ActiveRecord::Base
  belongs_to :game_stage
  attr_accessible :game_stage, :type, :x, :y
  set_inheritance_column :sub_type_class

  START_GENERATION = 1
  MAX_GENERATION = 10

  def self.convert_collection game_stage_id
    maps = GameMap.where(game_stage_id: game_stage_id).all
    maps.map do |m|
      {
        position: { x: m.x, y: m.y },
        type: m.convert_type,
        object: m.convert_object
      }
    end
  end

  def convert_object
    if self.type == Map::MAP_TYPE_USER_FUNGS
    { 
      id: self.id,
      current_generation: START_GENERATION,
      max_generation: MAX_GENERATION
    }
    else
    { id: self.id}
    end
  end

  def convert_type
    enemy = self.enemy.where(x: self.x, y: self.y).first(lock: true)
    virus = self.virus.where(x: self.x, y: self.y).first(lock: true)
    return Map::MAP_TYPE_USER_FUNGS if enemy
    return Map::MAP_TYPE_ENEMY_LEUKOCYTEL if virus
    return self.type
  end

  def enemy
    EnemyLeukocyte.where(game_stage_id: self.game_stage.id)
  end

  def virus
    UserFungus.where(game_stage_id: self.game_stage.id)
  end
end
