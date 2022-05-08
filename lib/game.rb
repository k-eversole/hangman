#Creates and plays a game of Hangman
require_relative 'logic'
require_relative 'display'
require_relative 'file_manager'

class Game
  include Logic
  include Display
  include FileManager
  attr_accessor :word, :dash_display, :wrong_guesses, :display, :body, :game_lost

  def initialize
    @word = word_select.split('')
    @dash_display = Array.new(word.length, "__")
    @wrong_guesses = []
    @body = ['', '', '', '', '', '', '']
    @game_lost = false
  end

  def start
    puts "Welcome to HANGMAN!"
    game_select
  end

  private
  def word_select
    dictionary = File.open("dictionary.txt", "r")
    words = []
    dictionary.each do |e|
      n = e.chomp
      if n.length.between?(5, 13)
        words << n
        end
      end
    dictionary.close
    words.sample
  end

  def game_select
    puts 'Do you want to start a new game (1) or load a saved game (2)?'
    while input = gets.chomp
      if input == '1'
        game = Game.new
        game.play_game
        break
      elsif input == '2'
        load_game
        break
      else puts "\nThat is not a valid input.\nDo you want to start a new game (1) or load a saved game (2)?"
      end
    end
  end

  def play_game
    until game_lost
      turn
      break if game_over?
    end
    turn_display
    end_game
  end

  def turn
    turn_display
    puts "\nGuess a letter."
    check_letters(player_input)
    puts "\n"
  end

  def turn_display
    show_gallows
    puts dash_display.join(" ")
    unless wrong_guesses.empty?
      puts "\nWrong guesses: #{wrong_guesses.sort.join(" ")}"
    end
  end

  def player_input
    while (input = gets.chomp.downcase)
      save_game if input.downcase == "save"
      return input if valid_input?(input)

      if wrong_guesses.include?(input) || dash_display.include?(input)
        puts '\nYou\'ve already guessed that letter. Try a different one.'
      else puts '\nThat is not a valid input. Please enter a letter.'
      end
    end
  end

  def valid_input?(input)
    input.match(/^[[:alpha:]]$/) &&
    input.length == 1 &&
    wrong_guesses.none?(input) &&
    dash_display.none?(input)
  end

  def check_letters(guess)
    correct_letter = false
    word.each_with_index do |letter, index|
      if letter == guess
        dash_display[index] = guess
        correct_letter = true
      end
    end
    if correct_letter == false
      draw_body
      wrong_guesses << guess
    end
  end

  def game_over?
    dash_display.none? { |n| n == "__" } || game_lost == true
  end

  def end_game
    if game_lost
      puts "\nYour word was: '#{word.join('')}'\n\nGAME OVER\n"
    else puts "\nYou won!\n\nGAME OVER\n"
    end
    game_select
  end
end
