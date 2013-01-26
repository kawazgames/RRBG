class GameStage < ActiveRecord::Base

  WAY_UP = 0
  WAY_DOWN = 1
  WAY_LEFT = 2
  WAY_RIGHT = 3
  WAY_STOP = 4
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

  ############################################################
  # Logic of turn
  ############################################################


  def get_way (v,t)
    y = t.y - v.y
    x = t.x - v.x
    return 0 if y == -1
    return 1 if y == 1
    return 2 if x == -1
    return 3 if x == 1
    4
  end

  def nears(i,j)
    [[i-1,j],[i+1,j],[i,j-1],[i,j+1]]
  end

  def near_spaces(i,j)
    nears(i,j).select{|a,b| !@enemys[a][b] && !@field[a][b] }
  end

  def duplicate_at(i,j)
    t = near_spaces(i,j).sample(1)[0]
    @enemys[t[0]][t[1]] = true if t
  end

  def step()

    @enemys = self.convert_enemy_step

    ls = @enemys.each_with_index.map {|x,i|
      x.each_with_index.map {|v,j|
        {i:i, j:j, c:near_spaces(i,j).length} if v
      }.select{|x| x}
    }.reduce(&:+)

    ls.sort_by{|a| a[:c] }.each{|x|
      t = near_spaces(x[:i], x[:j]).sample(1)[0]
      if t
        @enemys[t[0]][t[1]] = true
        @enemys[x[:i]][x[:j]] = false

        duplicate_at(t[0], t[1])
      end
    }

    @cleaner.each do |v|
      @enemys[v[:i]][v[:j]] = false
      10.times do
        t = nears(v[:i], v[:j]).select{|x| !@field[x[0]][x[1]] }.sample(1)[0]
        v[:i] = t[0]
        v[:j] = t[1]
        @enemys[v[:i]][v[:j]] = false
      end
    end
  end

  def convert_step
    enemys = UserFungus.where(game_stage_id: self.id).all(lock: true)
    @enemys = Array.new(8).map{ Array.new(8, false) }
    8.times do |x|
      8.times do |y|
        @enemys[y][x] << false
      end
    end
    enemys.each do |e|
      @enemys[e.y][e.x] << true
    end
    cleaner = EnemyLeukocyte.where(game_stage_id: self.id).all(lock: true)
    @cleaner = []
    cleaner.each do |e|
      @cleaner << {i: e.y, j: e.x}
    end
  end
end
