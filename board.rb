class Board

  ROWS = 9
  COLS = 9

  PERCENT_BOMBS = 0.1

  attr_accessor :grid

  def initialize
     @grid = Array.new(ROWS) { Array.new(COLS) { Tile.new } }
  end

  def seed
    self.grid.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        self[[row_idx, col_idx]] = Tile.new(rand < PERCENT_BOMBS)
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

        neighbors << [new_row, new_col] if Board.valid_pos?([new_row, new_col])
      end
    end

    neighbors
  end

  def neighbor_bomb_count(pos)
    count = 0

    self.neighbors(pos).each do |neighbor_pos|
      row, col = neighbor_pos
      neighbor = self.grid[row][col]
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

  def show(pos)
    queue = [pos]

    until queue.empty?
      current_pos = queue.shift

      tile = self[current_pos]

      tile.show

      if self.neighbor_bomb_count(current_pos) == 0 && !tile.bomb
        self.neighbors(current_pos).each do |neighbor_pos|
          neighbor = self[neighbor_pos]
          queue << neighbor_pos if neighbor.status == :hidden
        end
      end
    end
  end

  def flag(pos)
    self[pos].toggle_flag
  end

  def [](pos)
    row, col = pos
    self.grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    self.grid[row][col] = value
  end


end
