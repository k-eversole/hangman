#Creates and plays a game of Hangman
require_relative 'logic'

class Game
  include Logic
  attr_accessor :word, :dash_display, :wrong_guesses, :display

  def initialize
    @word = word_select.split('')
    @dash_display = Array.new(word.length, "__")
    @wrong_guesses = []
    @display = Display.new
  end
end