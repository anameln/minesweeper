require 'byebug'

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
