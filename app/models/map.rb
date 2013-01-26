class Map < ActiveRecord::Base
  belongs_to :stage

  attr_accessible :type, :x, :y
end
