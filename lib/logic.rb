#Contains logic needed to play Hangman
module Logic
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

  def player_input
    while (input = gets.chomp)
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

  def play_game
    puts "Welcome to Hangman!"
    until display.game_lost
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
    display.show_gallows
    puts dash_display.join(" ")
    unless wrong_guesses.empty?
      puts "\nWrong guesses: #{wrong_guesses.sort.join(" ")}"
    end
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
      display.draw_body
      wrong_guesses << guess
    end
  end

  def game_over?
    dash_display.none? { |n| n == "__" } || display.game_lost == true
  end

  def end_game
    if display.game_lost
      puts "\nYour word was: '#{word.join('')}'\n\nGAME OVER"
    else puts "\nYou won!\n\nGAME OVER"
    end
  end
end