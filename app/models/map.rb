class Map < ActiveRecord::Base
  belongs_to :stage
  MAP_TYPE_WALL = 0
  MAP_TYPE_NONE = 1
  MAP_TYPE_ENEMY_LEUKOCYTEL = 2
  MAP_TYPE_USER_FUNGS = 3

  attr_accessible :stage, :stage_id, :type, :x, :y
  set_inheritance_column :sub_type_class
end
