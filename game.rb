require_relative 'tile'
require_relative 'board'

class Game
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
      end
    end

    self.board.display

    if self.board.won?
      puts "You won!"
    else
      puts "You lose :("
    end
  end

  def prompt_user
    print "What is your move? "
    move = gets.chomp.split(",")

    row = move[0].to_i
    col = move[1].to_i

    if move[2] == 'f'
      action = :flag
    else
      action = :show
    end

    [row, col, action]
  end

end
