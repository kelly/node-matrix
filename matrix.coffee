class Matrix

  pixels: []
  
  initialize: (options) ->
    @rows = @options.rows
    @cols = @options.cols

    buildMatrixArray()

  numToHex: (num) ->
    num.toString(16)

  loop: (func) ->
    for row in @rows
      for col in @cols
        func()

  buildMatrixArray: ->
    i = 0
    for row in @rows
      rowPixels = []
      rowPixels.push new Pixel(address: @numToHex(i++)) for col in @cols
      @pixels.push rowPixels