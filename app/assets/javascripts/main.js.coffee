do ->
  Screen =
    width: 800
    height: 600

  Preloads = [
    'assets/kawaz.png'
    'assets/virus.png'
    'assets/leukocyte.png'
    'assets/space.png'
    'assets/wall.png'
    'assets/title.png'
    'assets/virus_move.wav'
    'assets/leukocyte_move.wav'
    'assets/item_get.wav'
  ]

  Size = 64
  Slide = 90

  game = setScene = undefined

  assets = (name) ->
    game.assets["assets/#{name}"]

  createLabel = (text, x, y, size, color) ->
    buf = new Label(text)
    buf.color = color
    buf.font = "#{size}px sans-serif"
    buf.x = x
    buf.y = y
    buf.opacity = 0.0
    buf.tl.fadeIn(10)
    buf

  createSprite = (sx, sy, x, y, image, opacity = 1.0) ->
    buf = new Sprite(sx, sy)
    buf.x = x
    buf.y = y
    buf.opacity = opacity
    buf.image = image
    buf

  wayMove = (base, way) ->
    switch way
      when 0
        {x: base.x, y: base.y - 1}
      when 1
        {x: base.x, y: base.y + 1}
      when 2
        {x: base.x - 1, y: base.y}
      when 3
        {x: base.x + 1, y: base.y}
      when 4
        {x: base.x, y: base.y}

  initTitle = ->
    scene = new Scene()

    logo = createSprite(270, 90, 265, 200, assets('kawaz.png'))
    logo.opacity = 0.0
    logo.tl.loop().fadeIn(20).delay(70).fadeOut(20).then ->
      setScene('top')

    scene.init = ->
    scene.addChild(logo)
    scene

  initTop = ->
    scene = new Scene()

    title = createSprite(800, 600, 0, 0, assets('title.png'))
    title.addEventListener Event.TOUCH_END, -> setScene('main')

    ranking = (createLabel("loading...", 150 + Math.floor(i/5)*350,
        350 + (i%5)*25, 16, '#333') for i in [0...10])

    scene.init = ->
      $.ajax
        type: 'get'
        url: '/games/ranking'
        data: null
        cache: false
        dataType: "json"
        success: (data) ->
          for v in data.ranking
            ranking[v.rank-1].text = "#{v.rank}: @#{v.screen_name} .. #{v.score}"

    scene.addChild(title)
    scene.addChild(v) for v in ranking
    scene

  initResult = ->
    scene = new Scene()

    title = createLabel("Result", 200, 250, 16, '#666')
    score = createLabel("SCORE", 200, 280, 16, '#666')
    retry = createLabel("retry", 550, 280, 16, '#666')
    retry.addEventListener Event.TOUCH_END, -> setScene('main')
    back = createLabel("back", 550, 310, 16, '#666')
    back.addEventListener Event.TOUCH_END, -> setScene('top')

    scene.score = score
    scene.init = (s) ->
      scene.score.text = s
      title.opacity = score.opacity = 0.0
      title.tl.fadeIn(10)
      score.tl.fadeIn(10)
    scene.addChild(title)
    scene.addChild(score)
    scene.addChild(retry)
    scene.addChild(back)
    scene

  initMain = ->
    scene = new Scene()
    id = connect = undefined
    group = groupEntity = undefined
    base = undefined
    score = createLabel("SCORE", 20, 20, 16, '#666')
    click = false

    addGroup = (g, x, y, image, alpha = 1.0) ->
      t = createSprite(Size, Size, Size*x, Size*y, image, alpha)
      g.addChild(t)
      t

    clearGroup = (all = false) ->
      if all
        scene.removeChild group if group
        group = new Group
        scene.addChild group

      scene.removeChild groupEntity if groupEntity
      groupEntity = new Group
      scene.addChild groupEntity

      if !all
        groupEntity.x = group.x
        groupEntity.y = group.y

    scene.init = ->
      clearGroup(true)

      connect = new Connect (data) ->
        
        id = data.id
        base = x: 0, y: 0

        for v in data.game_map
          base.x = v.position.x if base.x < v.position.x
          base.y = v.position.y if base.y < v.position.y

          addGroup(group, v.position.x, v.position.y, assets('space.png'))

          switch v.type
            when 0
              addGroup(group, v.position.x, v.position.y, assets('wall.png'))
            when 2
              addGroup(groupEntity, v.position.x, v.position.y, assets('leukocyte.png'))
            when 3
              addGroup(groupEntity, v.position.x, v.position.y, assets('virus.png'))

        group.x = (Screen.width - (base.x+1) * Size)/2 + Slide
        group.y = (Screen.height - (base.y+1) * Size)/2
        groupEntity.x = group.x
        groupEntity.y = group.y
        click = true

    scene.addEventListener Event.TOUCH_END, (e) =>
      return if !click
      target =
        x: Math.floor((e.localX - group.x)/Size)
        y: Math.floor((e.localY - group.y)/Size)
      connect.next_turn {id: id, virus: {position: target}}, (data) =>
        clearGroup()
        field = (new Array(base.x+1) for x in new Array(base.y+1))
        click = false
        assets("virus_move.wav").play()
        scene.tl.delay(30).then ->
          assets("leukocyte_move.wav").play()

        for v in data.game_stage.virus
          t = addGroup(groupEntity, v.x, v.y, assets('virus.png'))
          s = wayMove(v, v.way)
          field[s.x][s.y] = t
          t.tl.moveTo(s.x*Size, s.y*Size, 15)

        for v in data.game_stage.newvirus
          t = addGroup(groupEntity, v.x, v.y, assets('virus.png'), 0.0)
          t.tl.delay(15).fadeIn(15)

        for v,i in data.game_stage.leukocyte
          t = addGroup(groupEntity, v.x, v.y, assets('leukocyte.png'))
          t.tl.delay(30)
          for way in v.way
            v = wayMove(v, way)
            field[v.x][v.y]?.tl.fadeOut(10)
            t.tl.moveTo(v.x*Size, v.y*Size, 2)

          if i == 0
            t.tl.then ->
              score.text = "SCORE #{data.score}"
              if data.state == "gameover"
                setScene('result', score.text)
              else
                click = true

    scene.addChild score
    scene

  window.onload = ->
    enchant()

    game = new Game(Screen.width, Screen.height)
    game.preload(Preloads ...)
    game.onload = ->
      scenes = {}
      scenes.title = initTitle()
      scenes.top = initTop()
      scenes.main = initMain()
      scenes.result = initResult()

      setScene = (name, args ...) ->
        frame = 0
        scenes[name].init(args ...)
        game.replaceScene scenes[name]

      setScene('top')

    game.start()

