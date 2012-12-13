five = require 'johnny-five'
util = require 'util' 
Pixel = require './lib/pixel'

board = new five.Board()


board.on "ready", ->
  pixel1 = new Pixel address: 0x01
  board.repl.inject pixel1: pixel1
  pixel2 = new Pixel address: 0x02
  board.repl.inject pixel2: pixel2
  pixel3 = new Pixel address: 0x03
  board.repl.inject pixel3: pixel3