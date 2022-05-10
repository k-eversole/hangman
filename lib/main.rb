# frozen_string_literal: true

# Official code happens here

require_relative 'game'
require_relative 'display'
require_relative 'file_manager'
require 'yaml'
require 'colorize'

game = Game.new
game.start
