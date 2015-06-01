require 'yaml'
require_relative 'tile'
require_relative 'board'

class Game

  def self.initialize_from(filename)
    contents = File.read(filename)
    board = YAML.load(contents)

    Game.new(board)
  end

  attr_reader :board

  def initialize(board = Board.new)
    @board = board
  end

  def play
    until self.board.lost? || self.board.won?
      self.board.display

      row, col, action = self.prompt_user

      if action == :flag
        self.board.flag([row,col])
      elsif action == :show
        self.board.show([row, col])
      elsif action == :quit
        self.save

        break
      end
    end

    self.board.display

    if self.board.won?
      puts "You won!"
    elsif self.board.lost?
      puts "You lose :("
    end
  end

  def prompt_user
    print "What is your move (q for quit)? "
    response = gets.chomp

    if response == 'q'
      return [-1, -1, :quit]
    end

    move = response.split(",")

    row = move[0].to_i
    col = move[1].to_i

    case move[2]
    when 'f'
      action = :flag
    when 's'
      action = :show
    end

    [row, col, action]
  end

  def save
    print "What file do you want to save your game to? "
    filename = gets.chomp

    File.open(filename,'w') do |f|
      f.print self.board.to_yaml
    end

    puts "Game successfully saved to #{filename}"
  end
end
