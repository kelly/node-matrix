EventEmitter = require('events').EventEmitter
five = require 'johnny-five'
_ = require 'underscore' 
util = require 'util' 

# interface found at http://code.google.com/p/codalyze/wiki/CyzRgb

class Pixel

  color: '#000000'
  address: 0x00
  connected: false

  initialize: (options) ->
    @address = options.address
    @firmata = @board.firmata

    @firmata.sendI2CConfig()
    @wait 100, ->
      @check()

  send: (cmds) ->
    if @connected 
      @firmata.sendI2CWriteRequest @address, cmds
    else
      @emit 'error', 'not connected'

  read: (bytes, callback) ->
    @firmata.sendI2CReadRequest bytes, callback

  off: ->
    @setFadeSpeed(10);
    @setRGB(addr, 0,0,0 );

  setAddress: (address) ->
    @send ['A',
          address,
          0xD0,
          0x0D,
          address]

  check: ->
    @getAddress()
    @on 'address:set', (address) ->
      if address == @address then @connected = true

  getAddress: ->
    @send ['a']
    @read 1, (data) =>
      @emit 'address:set', data      

  setFadeSpeed: (speed) ->
    @send ['f', speed]

  # color functions
  setRGB: (r, g, b) ->
    @send ['n', r, g, b]
    @color = RGBToHex(r, g, b)

  getRGB: ->
    @send ['g']
    @read 3, (data) =>
      console.log data

  setHex: (hex) ->
    rgb = @hexToRGB hex
    @setRGB rgb.r, rgb,g, rgb.b
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
    @send ['c', r, g, b]

  fadeToHSB: (h, s, b) ->
    @send ['h', h, s, b]


util.inherits Pixel, events.EventEmitter

module.exports = Pixel