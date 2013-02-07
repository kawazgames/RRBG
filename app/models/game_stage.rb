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

  MOVE_LEUKOCYTE = 50

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
      Map.where(stage_id: id).pickin(GameMap, {game_stage_id: @res.id}, [:id])
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
    y = t[:y] - v[:y]
    x = t[:x] - v[:x]
    return WAY_UP if y == -1
    return WAY_DOWN if y == 1
    return WAY_LEFT if x == -1
    return WAY_RIGHT if x == 1
    WAY_STOP
  end

  def nears(i,j)
    [[i-1,j],[i+1,j],[i,j-1],[i,j+1]]
  end

  def near_spaces(i,j)
    nears(i,j).select do |e|
      !@enemys[e[0]][e[1]] && !@field[e[0]][e[1]]
    end
  end

  def duplicate_at(i,j)
    t = near_spaces(i,j).sample(1)[0]
    @enemys[t[0]][t[1]] = true if t
    UserFungus.create! game_stage: self, y: t[0], x: t[1]
    @new_fungus << UserFungus.new(game_stage: self, y: t[0], x: t[1])
  end

  def set_and_step(y, x)
    GameStage.transaction do
      @new_fungus = []
      @new_fungus << UserFungus.new(game_stage: self, y: y, x: x)
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
        @enemys_obj[x[:i]][x[:j]].update_attributes!(y: t[0], x: t[1])
        @moved_enemy << { y:t[0], x:t[1], way: WAY_STOP }
        duplicate_at(t[0], t[1])
      else
        @moved_enemy << { y:x[:i], x:x[:j], way: WAY_STOP }

      end

    }

    # TODO use activerecord-import
    @new_fungus.map{|m| m.save! }

    @moved_cleaner = []
    @cleaner.each_with_index do |v, ci|
    way = []
    nv = {}
    fv = v
      died_ids = []
      @enemys[v[:y]][v[:x]] = false
      MOVE_LEUKOCYTE.times do
        t = nears(v[:y], v[:x]).select{|x| !@field[x[0]][x[1]] }.sample(1)[0]
        nv = { y: t[0], x: t[1] }
        if @enemys_obj[nv[:y]][nv[:x]]
          @enemys[nv[:y]][nv[:x]] = false
          died_ids << @enemys_obj[nv[:y]][nv[:x]].id
          @enemys_obj[nv[:y]][nv[:x]] = nil
        end
        way << self.get_way({y: v[:y], x: v[:x]}, {y: t[0], x: t[1]})
        v = nv
      end
      @moved_cleaner << { y: fv[:y], x: fv[:x], way: way }
      UserFungus.where(id: died_ids).update_all(status: EnemyLeukocyte::DIED) unless died_ids.empty?
      @cleaner_obj[fv[:y]][fv[:x]].update_attributes!(y: nv[:y], x: nv[:x])
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
        @field[y][x] = @field_obj[y][x].is_wall?
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
      @cleaner << {y: e.y, x: e.x, object_id: e.id}
      @cleaner_obj[e.y][e.x] = e
    end
  end

  def convert_structure
  {
    newvirus: @new_fungus.map{|m| {x: m.x, y: m.y}},
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
