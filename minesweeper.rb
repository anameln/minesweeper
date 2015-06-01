class Tile
  attr_reader :bomb
  attr_accessor :status

  def initialize(bomb = false)
    @bomb = bomb
    @status = :hidden
  end

  def toggle_flag
    return if self.status == :showing

    self.status = self.status == :flagged ? :hidden : :flagged
  end

  def show
    return if self.status == :showing

    self.status = :showing
  end
end

class Board

  ROWS = 9
  COLS = 9

  attr_accessor :grid

  def initialize
     @grid = Array.new(ROWS) { Array.new(COLS) { Tile.new } }
  end

  def seed
    self.grid.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        self.grid[row_idx][col_idx] = Tile.new(rand < 0.2)
      end
    end
  end

  def neighbors(pos)
    row, col = pos
    neighbors = []

    [-1,0,1].each do |d_row|
      [-1,0,1].each do |d_col|
        next if [d_row, d_col] == [0, 0]
        new_row = row + d_row
        new_col = col + d_col

        neighbors << self.grid[new_row][new_col] if Board.valid_pos?([new_row, new_col])
      end
    end

    neighbors
  end

  def neighbor_bomb_count(pos)
    count = 0

    self.neighbors(pos).each do |neighbor|
      count += 1 if neighbor.bomb == true
    end

    count
  end

  def self.valid_pos?(pos)
    row, col = pos

    row.between?(0, ROWS - 1) && col.between?(0, COLS - 1)
  end

  def display
    self.grid.each_with_index do |row, row_idx|
      row_str = ""

      row.each_with_index do |tile, col_idx|
        if tile.status == :hidden
          row_str << "*"
        elsif tile.status == :flagged
          row_str << "F"
        elsif tile.bomb
          row_str << "X"
        else
          num = self.neighbor_bomb_count([row_idx, col_idx])
          if num > 0
            row_str << num.to_s
          else
            row_str << "_"
          end
        end
      end

      puts row_str
    end
  end
end

class Game
  def initialize
    @board = Board.new
  end
end
