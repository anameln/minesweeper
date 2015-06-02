require 'yaml'
require_relative 'tile'
require_relative 'board'

class InvalidMoveTypeError < StandardError
end

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
      puts "You won! 😄"
    elsif self.board.lost?
      puts "You lose 💩"
    end
  end

  def prompt_user
    begin
      print "What is your move (q for quit)? "
      response = gets.chomp
      response = response.split(",")
      valid_r = ["q", "s", "f"]
      raise InvalidMoveTypeError.new if !valid_r.include?(response[-1])

      row = response[0].to_i
      col = response[1].to_i

      raise ArgumentError.new("Row out of range") unless row.between?(0, Board::ROWS - 1)
      raise ArgumentError.new("Col out of range") unless col.between?(0, Board::COLS - 1)

    rescue InvalidMoveTypeError => e
      puts "Invalid move, try again."
      retry
    rescue ArgumentError => e
      puts e.message
      puts "Try again."
      retry
    end

    if response == 'q'
      return [-1, -1, :quit]
    end



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

if $PROGRAM_NAME == __FILE__
  if ARGV.count > 0
    filename = ARGV.shift
    game = Game.initialize_from(filename)
  else
    game = Game.new
  end

  game.play
end
