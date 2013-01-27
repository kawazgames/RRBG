class GameMap < ActiveRecord::Base
  belongs_to :game_stage
  attr_accessible :game_stage, :type, :x, :y
  set_inheritance_column :sub_type_class

  START_GENERATION = 1
  MAX_GENERATION = 10

  def convert_collection
    maps = GameMap.where(game_stage_id: self.game_stage.id).all
    maps.map do |m|
      {
        position: { x: m.x, y: m.y },
        type: m.convert_type,
        object: m.convert_object
      }
    end
  end

  def convert_object
    if Map::MAP_TYPE_USER_FUNGS
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
    if enemy.nil? and virus.nil?
      self.type
    elsif enemy.nil?
      Map::MAP_TYPE_USER_FUNGS
    else
      Map::MAP_TYPE_ENEMY_LEUKOCYTEL
    end
  end

  def enemy
    EnemyLeukocyte.where(game_stage_id: self.game_stage.id)
  end

  def virus
    UserFungus.where(game_stage_id: self.game_stage.id)
  end
end
