class Game
  def initialize
    @board = Board.new
  end

  def play
    @board.seed
    until self.lost? || self.won?
      @board.display

      row, col, action = self.prompt_user

      if action == :flag
        @board.flag([row,col])
      elsif action == :show
        @board.show([row, col])
      end
    end

    @board.display

    if self.won?
      puts "You won!"
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
    #debugger
    [row, col, action]
  end

  def lost?
    @board.grid.each do |row|
      row.each do |tile|
        return true if tile.status == :showing && tile.bomb
      end
    end

    false
  end

  def won?
    @board.grid.each do |row|
      row.each do |tile|
        return false if tile.status == :hidden && !tile.bomb
      end
    end

    true
  end
end
