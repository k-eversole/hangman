module FileManager
  def load_game
    filename = choose_file
    saved_game = File.open(File.join(Dir.pwd, "/saves/#{filename}.yaml"), 'r')
    loaded_game = YAML.load(saved_game)
    puts "\nGame loaded.\n"
    loaded_game.play_game
  end

  def choose_file
    if !Dir.exists?('saves')
      puts "\nThere are no saved games.\n"
    else puts "\nPlease enter the file you would like to load.\nSave files:"
      save_list = Dir.glob('saves/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
      save_list.each{ |file| puts file }
      while input = gets.chomp.strip
        if save_list.include?(input)
          return input
        else puts '\nThere is no save of that name.'
        end
      end
    end
  end

  def save_game
    puts "\nEnter a file name for your save."
    filename = get_save_name
    Dir.mkdir('saves') unless Dir.exists?('saves')
    File.open(File.join(Dir.pwd, "/saves/#{filename}.yaml"), 'w') { |file| file.write(YAML.dump(self)) }
    puts "\nGame saved. Continue playing?"
    quit_or_continue
  end

  def quit_or_continue
    while input = gets.chomp
      if input[0].downcase == 'y'
        play_game
        break

      elsif input[0].downcase == 'n'
        puts "Thanks for playing!"
        break

      else puts "Invalid input. Continue playing?"
      end
    end
  end

  def get_save_name
    save_list = Dir.glob('saves/*')
    while input = gets.chomp.strip
      if !save_list.include?("saves/#{input}.yaml") && !/\s+|^$/.match?(input)
        return input
      else puts "\nThere is already a save of that name."
      end
    end
  end
end