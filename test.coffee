five = require 'johnny-five'
util = require 'util' 
Pixel = require './pixel'

board = new five.Board()


board.on "ready", ->
  pixel = new Pixel address: 0x01
  board.repl.inject pixel: pixel