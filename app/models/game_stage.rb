require 'yaml'
class GameStage < ActiveRecord::Base

  WAY_UP = 0
  WAY_DOWN = 1
  WAY_LEFT = 2
  WAY_RIGHT = 3
  WAY_STOP = 4
  ONE_LINE = 10

  STATE_PLAYING = 0
  STATE_GAMEOVER = 1
  CLEAR_RATION = 70

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
      game_map: GameMap.convert_collection(self.id)

    }
  end

  ############################################################
  # Logic of turn
  ############################################################


  def play_status
    fungus = UserFungus.where(game_stage_id: self.id, status: UserFungus::LIFE).count(lock: "LOCK IN SHARE MODE")
    return STATE_GAMEOVER if fungus >= CLEAR_RATION
    return STATE_PLAYING
  end

  def get_way (v,t)
    y = t[:y] - v[0]
    x = t[:x] - v[1]
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

  def set_and_step(y, x)
    GameStage.transaction do
      @new_fungus = UserFungus.create! game_stage: self, y: y, x: x
      self.step()
    end
    self.convert_structure
  end
  def step()

    self.convert_step

    @moved_enemy = []
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
        @enemys_obj[x[:i]][x[:j]].update_attributes(y: t[0], x: t[1])
        @moved_enemy << { y:t[0], x:t[1], way: self.get_way(t,{y: x[:i], x: x[:j]}) }
        duplicate_at(t[0], t[1])
      end

    }


    @moved_cleaner = []
    nv = {}
    @cleaner.each do |v|
      @enemys[v[:i]][v[:j]] = false
      10.times do
        t = nears(v[:i], v[:j]).select{|x| !@field[x[0]][x[1]] }.sample(1)[0]
        nv[:i] = t[0]
        nv[:j] = t[1]
        if @enemys_obj[nv[:i]][nv[:j]]
          @enemys[nv[:i]][nv[:j]] = false
          @enemys_obj[nv[:i]][nv[:j]].update_attributes(status: EnemyLeukocyte::DIED)
        end
        @moved_cleaner << { y:t[0], x:t[1], way: self.get_way(t,{y: v[:i], x: v[:j]}) }
      end
      @cleaner_obj[v[:i]][v[:j]].update_attributes(y: nv[:i], x: nv[:j])
    end
  end

  def convert_step
    field = GameMap.where(game_stage_id: self.id).all
    # TODO lock for stage?
    @enemys_lock = UserFungus.where(game_stage_id: self.id, status: UserFungus::LIFE).all(lock: true)
    @enemys = Array.new(ONE_LINE).map{ Array.new(ONE_LINE, false) }
    @enemys_obj = Array.new(ONE_LINE).map{ Array.new(ONE_LINE, false) }
    @field = Array.new(ONE_LINE).map{ Array.new(ONE_LINE, false) }
    @field_obj = Array.new(ONE_LINE).map{ Array.new(ONE_LINE, false) }
    field.each do |f|
      @field[f.y][f.x] = false
      @field_obj[f.y][f.x] = f
    end
    ONE_LINE.times do |x|
      ONE_LINE.times do |y|
        @enemys[y][x] = false
        @field[y][x] = false
        @field[y][x] = true if @field_obj[y][x] and @field_obj[y][x].type == Map::MAP_TYPE_WALL
      end
    end
    @enemys_lock.each do |e|
      if e.y and e.x
        @enemys[e.y][e.x] = true
        @enemys_obj[e.y][e.x] = e
        UserFungus.create! game_stage: self, y: e.y, x: e.x
      end
    end
    cleaner = EnemyLeukocyte.where(game_stage_id: self.id, status: EnemyLeukocyte::LIFE).all(lock: true)
    @cleaner = []
    @cleaner_obj = Array.new(ONE_LINE).map{ Array.new(ONE_LINE, false) }
    cleaner.each do |e|
      @cleaner << {i: e.y, j: e.x, object_id: e.id}
      @cleaner_obj[e.y][e.x] = e
    end
    p @cleaner_obj
  end

  def convert_structure
  {
    newvirus: {x: @new_fungus.x, y: @new_fungus.y},
    leukocyte: @moved_cleaner,
    virus: @moved_enemy
  }
  end

  def get_score
    fungus = UserFungus.where(game_stage_id: self.id, status: UserFungus::LIFE).count(lock: true)
    leukocyte = EnemyLeukocyte.where(game_stage_id: self.id, status: EnemyLeukocyte::LIFE).count(lock: true)
    return ((leukocyte) * (fungus * 1000 / (ONE_LINE * ONE_LINE))) + 20
  end
end
