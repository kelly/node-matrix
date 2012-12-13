class Layer extends EventEmitter

  array: []
  animated: false

  constructor: (options) ->
    @position = options.position

  clear: () ->

  loop: (func) ->
    for row in @rows
      for col in @cols
        func.call(@, row, col)

  setColors: (array) ->
    @loop @setColor r, c, array[r][c]

  setColorAt: (r, c, color) ->
    @array[r][c] = color

  merge: (array) ->
