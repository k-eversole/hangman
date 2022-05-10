# frozen_string_literal: true

require_relative 'display'
require_relative 'file_manager'

# Creates and plays a game of Hangman
class Game
  include Display
  include FileManager
  attr_accessor :game_lost

  def initialize
    @word = word_select.split('')
    @dash_display = Array.new(@word.length, '__')
    @wrong_guesses = []
    @body = ['', '', '', '', '', '', '']
    @game_lost = false
  end

  def start
    puts 'Welcome to HANGMAN!'
    game_select
  end

  def play_game
    until @game_lost
      turn
      break if game_over?
    end
    turn_display
    end_game
  end

  private

  def word_select
    dictionary = File.open('dictionary.txt', 'r')
    words = []
    dictionary.each do |e|
      n = e.chomp
      words << n if n.length.between?(5, 13)
    end
    dictionary.close
    words.sample
  end

  def game_select
    puts "\nDo you want to start a new game (1) or load a saved game (2)?"
    while (input = gets.chomp)
      case input
      when '1'
        game = Game.new
        game.play_game
      when '2'
        load_game
      else
        puts "\nThat is not a valid input.".red
        puts "\nDo you want to start a new game (1) or load a saved game (2)?"
      end
    end
  end

  def turn
    turn_display
    puts "\nGuess a letter."
    check_letters(player_input)
    puts "\n"
  end

  def turn_display
    show_gallows
    puts @dash_display.join(' ')
    return if @wrong_guesses.empty?

    puts "\nWrong guesses: #{@wrong_guesses.sort.join(' ')}"
  end

  def player_input
    while (input = gets.chomp.downcase)
      save_game if input.downcase == 'save'
      return input if valid_input?(input)

      if @wrong_guesses.include?(input) || @dash_display.include?(input)
        puts "\nYou\'ve already guessed that letter. Try a different one."
      else puts "\nThat is not a valid input. Please enter a letter.".red
      end
    end
  end

  def valid_input?(input)
    input.match(/^[[:alpha:]]$/) &&
      input.length == 1 &&
      @wrong_guesses.none?(input) &&
      @dash_display.none?(input)
  end

  def check_letters(guess)
    correct_letter = false
    @word.each_with_index do |letter, index|
      if letter == guess
        @dash_display[index] = guess
        correct_letter = true
      end
    end
    return unless correct_letter == false

    draw_body
    @wrong_guesses << guess
  end

  def game_over?
    @dash_display.none? { |n| n == '__' } || @game_lost == true
  end

  def end_game
    if @game_lost
      puts "\nYour word was: '#{@word.join('')}'\n\nGAME OVER\n"
    else puts "\nYou won!\n\nGAME OVER\n"
    end
    game_select
  end
end
