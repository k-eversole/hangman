#Official code happens here

require_relative 'game'
require_relative 'logic'
require_relative 'display'
require_relative 'file_manager'
require 'yaml'

game = Game.new
game.start