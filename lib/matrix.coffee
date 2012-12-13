# Pixel = require './pixel'
_ = require 'underscore'

class PixelMatrix

  layers: []
  pixels: []
  
  constructor: (options = {}) ->

    # defaults to 64 pixel grid
    _.defaults options,
      rows: 8
      cols: 8
      start: 0x00
      end: 0x64

    @rows = options.rows
    @cols = options.cols

    @buildMatrixArray()

  loop: (func) ->
    for row in [0..@rows - 1]
      for col in [0..@cols - 1]
        func.call(@, row, col)

  addChild: (layer) ->
    layers.push layer

  removeChild: (layer) ->

  toTop: (layer) ->

  flatten: ->
    for layer in @layers
      @loop (r, c) ->
        # if r + layer.pos.y 

  update: (array) ->
    @loop @pixels[r][c].setColor array[r][c]

  clear: ->
    @layers = []
    @loop (r, c) ->
      @pixels[r][c].off()

  buildMatrixArray: ->
    i = 1
    for row in [0..@rows - 1]
      rowPixels = []
      rowPixels.push i++ for col in [0..@cols - 1]
      # rowPixels.push new Pixel(address: @numToHex(i++)) for col in @cols
      @pixels.push rowPixels

module.exports = PixelMatrix