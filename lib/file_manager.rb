# frozen_string_literal: true

# saves and loads the game
module FileManager
  def load_game
    filename = choose_file
    saved_game = File.open(File.join(Dir.pwd, "/saves/#{filename}.yaml"), 'r')
    loaded_game = YAML.safe_load(saved_game, permitted_classes: [Game])
    puts "\nGame loaded.\n"
    loaded_game.play_game
  end

  def choose_file
    if !Dir.exist?('saves')
      puts "\nThere are no saved games.".red
      game_select
    else search_saves
    end
  end

  def search_saves
    puts "\nPlease enter the file you would like to load.\nSave files:"
    save_list = Dir.glob('saves/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
    save_list.each { |file| puts file }
    while (input = gets.chomp.strip)
      return input if save_list.include?(input)

      puts "\nThere is no save of that name. Please enter a save file to load.".red
    end
  end

  def save_game
    puts "\nEnter a file name for your save."
    filename = name_save
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open(File.join(Dir.pwd, "/saves/#{filename}.yaml"), 'w') { |file| file.write(YAML.dump(self)) }
    puts "\nGame saved. Continue playing?"
    quit_or_continue
  end

  def quit_or_continue
    while (input = gets.chomp)
      case input[0].downcase
      when 'y'
        play_game
      when 'n'
        puts "\nThanks for playing!"
        exit
      else puts "\nInvalid input.".red
        puts "\nContinue playing?"
      end
    end
  end

  def name_save
    save_list = Dir.glob('saves/*')
    while (input = gets.chomp.strip)
      return input if !save_list.include?("saves/#{input}.yaml") && !/\s+|^$/.match?(input)

      puts "\nThere is already a save of that name.".red
    end
  end
end
