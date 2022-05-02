require_relative 'logic'

# Controls the Hangman figure progression
class Display
  include Logic
  attr_accessor :body, :game_lost

  def initialize
    @body = ['', '', '', '', '', '', '']
    @game_lost = false
  end

  def show_gallows
    puts <<~HEREDOC
   ______
  |/     |
  |      #{body[0]}
  |     #{body[3]}#{body[1]}#{body[4]}
  |      #{body[2]}
  |     #{body[5]} #{body[6]}
  |
 /|\\
/ | \\
^^^^^^^^^^^^^
    HEREDOC
  end

  def draw_body
    part = body.find_index(&:empty?)
    case part
    when 0
      body[part] = 'O'
    when 1
      body[part] = ' |'
      body[2] = '|'
    when 3
      body[part] = '\\'
      body[1] = '|'
    when 4
      body[part] = '/'
    when 5
      body[part] = '/'
    when 6
      body[part] = '\\'
      self.game_lost = true
    end
  end
end