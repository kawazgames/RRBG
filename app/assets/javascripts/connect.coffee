###
# app/assets/javascripts/connect.js
# connect wrapper
###

CellType =
  "#": 0
  ".": 1
  "X": 2
  "@": 3

Way =
  Up: 0
  Down: 1
  Left: 2
  Right: 3
  Stop: 4

Array::sample = ->
  return undefined if !this.length
  this[Math.floor(Math.random()*this.length)]

class ConnectTest
  @map: [
    "##########",
    "#..#..#..#",
    "#......#.#",
    "#...##...#",
    "#..#..#..#",
    "#..#..#..#",
    "#.....X..#",
    "#.#.###..#",
    "#...#....#",
    "##########"]

  constructor: (f) ->
    f({
      id: 111,
      game_map: ({
        position: {x: x, y: y},
        type: CellType[v]
      } for v,x in ls.split("") for ls,y in ConnectTest.map)
    })

    @field = (v == "#" for v in ls.split("") for ls in ConnectTest.map)
    @virus = (false for x in [0..10] for y in [0..10])
    @leukocyte = [{y:6,x:6}]

  next_turn: (data, f) ->
    if data.id != 111
      @error.push "invalid id"
      return

    result = @step(data.virus.position)

    f({ state: "playing", game_stage: result })

  nears: (y,x) ->
    [{y:y-1,x:x},{y:y+1,x:x},{y:y,x:x-1},{y:y,x:x+1}]

  near_spaces: (y,x) ->
    (v for v in @nears(y,x) when !@virus[v.y][v.x] && !@field[v.y][v.x])

  get_way: (v,t) ->
    y = t.y - v.y
    x = t.x - v.x
    return 0 if y == -1
    return 1 if y == 1
    return 2 if x == -1
    return 3 if x == 1
    4

  step: (place) ->
    result =
      virus: []
      newvirus: []
      leukocyte: []

    duplicate_at = (y,x) =>
      t = @near_spaces(y,x).sample()
      return if !t
      @virus[t.y][t.x] = true
      result.newvirus.push({x: t.x, y: t.y})

    ls = Array::concat.apply([], (({y:y, x:x, c:@near_spaces(y,x).length} for v, x in ls when v) for ls, y in @virus) )

    for v in ls.sort((a,b) -> a.c - b.c)
      t = @near_spaces(v.y, v.x).sample()
      if t
        @virus[v.y][v.x] = false
        @virus[t.y][t.x] = true
        result.virus.push({ y:v.y, x:v.x, way:@get_way(v,t) })
        duplicate_at(t.y, t.x)
      else
        result.virus.push({ y:v.y, x:v.x, way:4 })

    @virus[place.y][place.x] = true
    result.newvirus.push(place)

    for v in @leukocyte
      r = { y:v.y, x:v.x, way: [] }
      @virus[v.y][v.x] = false
      for _ in [0...10]
        t = (w for w in @nears(v.y, v.x) when !@field[w.y][w.x]).sample()
        r.way.push(@get_way(v,t))
        v.y = t.y
        v.x = t.x
        @virus[v.y][v.x] = false
      result.leukocyte.push(r)
    result

class Connect
  constructor: (f) ->
    @error = []
    options =
      type: "get"
      url: "/games/new"
      data: null
      success: f
    @request options

  request: (options) ->
    $.ajax
      type: options.type
      url: options.url
      data: options.data
      cache: false
      dataType: "json"
      success: (data) ->
        options.success?(data)
      error: (error) =>
        @error.push error
        if confirm "通信エラー。再試行しますか？"
          @request options

  next_turn: (data, f) ->
    options =
      type: "post"
      url: "/games/next_turn"
      data: data
      success: f
    @request options

exports = this

exports.CellType = CellType
exports.Way = Way
exports.ConnectTest = ConnectTest
exports.Connect = Connect

# Usage
# connect = new Connect (res) ->
# connect.next_turn req, (res) ->

