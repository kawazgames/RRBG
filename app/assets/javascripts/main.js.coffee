do ->
  Screen =
    width: 800
    height: 600

  Preloads = [
    'assets/kawaz.png'
  ]

  game = setScene = undefined

  addNewLabel = (text, x, y, size, color) ->
    buf = new Label(text)
    buf.color = color
    buf.font = "#{size}px sans-serif"
    buf.x = x
    buf.y = y
    buf.opacity = 0.0
    buf.tl.fadeIn(10)
    buf

  initTitle = ->
    scene = new Scene()

    logo = new Sprite(270,90)
    logo.image = game.assets['assets/kawaz.png']
    logo.x = 265
    logo.y = 200
    logo.opacity = 0.0
    logo.tl.loop().fadeIn(20).delay(70).fadeOut(20).then ->
    logo.tl.then ->
      setScene('top')

    scene.init = ->
    scene.addChild(logo)
    scene

  initTop = ->
    scene = new Scene()

    title = addNewLabel("RRBG(仮)", 200, 300, 16, '#666')
    start = addNewLabel("GAME START", 200, 320, 16, '#666')
    start.addEventListener Event.TOUCH_END, ->
      #setScene('main')

    scene.init = ->
    scene.addChild(title)
    scene.addChild(start)
    scene

  window.onload = ->
    enchant()

    game = new Game(Screen.width, Screen.height)
    game.preload(Preloads ...)
    game.onload = ->
      scenes = {}
      scenes.title = initTitle()
      scenes.top = initTop()

      setScene = (name) ->
        frame = 0
        scenes[name].init()
        game.replaceScene scenes[name]
      game.pushScene(scenes.title)

    game.start()

