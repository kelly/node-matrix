EventEmitter = require('events').EventEmitter
Board = require 'johnny-five/lib/board'
util = require 'util' 
compulsive = require 'compulsive' 

# constants
# found at http://code.google.com/p/codalyze/wiki/CyzRgb

TO_RGB =        0x6e
GET_RGB =       0x67
FADE_TO_RGB =   0x63
FADE_TO_HSB =   0x68
GET_ADDRESS =   0x61
SET_ADDRESS =   0x41
SET_FADE =      0x66
GET_VERSION =   0x5a
WRITE_SCRIPT =  0x57
READ_SCRIPT =   0x52
PLAY_SCRIPT =   0x70
STOP_SCRIPT =   0x0f

class Pixel extends EventEmitter

  address: 0x01
  connected: true

  constructor: (options = {}) ->
    @address = options.address

    @board = Board.mount()
    @firmata = @board.firmata

    @firmata.sendI2CConfig()
    @setRGB 255,255,255
    # @wait 100, =>
    #   @check()

  send: (cmds) ->
    if @connected 
      console.log "sending #{cmds}"
      @firmata.sendI2CWriteRequest @address, cmds
    else
      @emit 'error', 'not connected'

  read: (length, callback) ->
    @firmata.sendI2CReadRequest @address, length, callback

  off: ->
    @setFadeSpeed(10)
    @setRGB(0, 0, 0)

  setAddress: (address) ->
    @send [SET_ADDRESS,
          address,
          '0xD0',
          '0x0D',
          address]
    @address = address

  check: ->
    @getAddress()
    @on 'address:read', (address) ->
      if address == @address then @connected = true

  getAddress: ->
    @send [GET_ADDRESS]
    @read 1, (data) =>
      console.log data
      @emit 'address:read', data

  setFadeSpeed: (speed) ->
    @send [SET_FADE, speed]

  # color functions
  setRGB: (r, g, b) ->
    @send [TO_RGB, r, g, b]
    @color = @RGBToHex(r, g, b)

  getRGB: ->
    @send [GET_RGB]
    @read 3, (data) =>
      console.log data

  setHex: (hex) ->
    rgb = @hexToRGB hex
    @setRGB rgb.r, rgb.g, rgb.b
    @color = hex

  RGBToHex: (r, g, b) ->
    return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1)

  hexToRGB: (hex) ->
    result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
    return if result 
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
      else null

  fadeToRGB: (r, g, b) ->
    @send [FADE_TO_RGB, r, g, b]
    @color = @RGBToHex(r, g, b)

["wait"].forEach (api) ->
  Pixel::[api] = compulsive[api]

module.exports = Pixel