class Matrix

  pixels: []
  
  constructor: (options = {}) ->
    @rows = @options.rows
    @cols = @options.cols

    buildMatrixArray()

  numToHex: (num) ->
    num.toString(16)

  loop: (func) ->
    for row in @rows
      for col in @cols
        func.call(@, row, col)

  clear: () ->
    @loop (r, c) ->
      @pixels[r][c].off()

  set: (r, c, color) ->
    @pixels[r,c].setHex color

  buildMatrixArray: ->
    i = 0
    for row in @rows
      rowPixels = []
      rowPixels.push new Pixel(address: @numToHex(i++)) for col in @cols
      @pixels.push rowPixels