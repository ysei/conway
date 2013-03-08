#!/usr/bin/env ruby
require 'matrix'

class Cell
  def initialize status
    @status = status
  end
  
  def update_live_neighbors_to live_neighbor_count
    raise ArgumentError, "A cell can't have more than 8 neighbors" if live_neighbor_count > 8
    @live_neighbors = live_neighbor_count
  end
  
  def step
    if alive?
      die if @live_neighbors < 2
      die if @live_neighbors > 3
    else
      live if @live_neighbors == 3
    end
  end
  
  def live
    @status = :alive
  end
  
  def die
    @status = :dead
  end
  
  def alive?
    @status == :alive
  end
  
  def to_s
    alive? ? '#': ' '
  end
end


class Matrix
  alias_method :get_cell_original, :[]
  def [](i, j)
    return nil if i < 0 || j < 0
    get_cell_original(i, j)
  end
end


class GameOfLife
  attr_reader :field
  
  def initialize(height, width, probability=0.25)
    @height, @width, @probability = height, width, probability
    create_seed
  end
  
  def create_seed
    @field = Matrix.build(@height, @width){ |row, column| Cell.new(@probability > rand ? :alive : :dead) }
  end
  
  def tick
    update_cells_neighbor_count
    @field.each_with_index do |cell, row, column|
      cell.step
    end
    system('clear')
    puts self
  end
  
  def update_cells_neighbor_count
    @field.each_with_index do |cell, row, column|
      cell.update_live_neighbors_to live_neighbors_for(row, column)
    end
  end
  
  def go(ticks=1)
    ticks.times do |s|
      tick
      puts "="*80, "Generation: #{s + 1}"
    end
  end
  
  def live_neighbors_for(row, column)
    neighbors.inject(0) do |count, (row_offset, column_offset)|
      neighbor = @field[row + row_offset, column + column_offset]
      count += 1 if !neighbor.nil? && neighbor.alive?
      count
    end
  end
  
  def neighbors
    [-1, 0, 1].repeated_permutation(2).reject{ |perm| perm == [0, 0] }
  end
  
  def to_s
    @field.row_vectors().map{ |vector| vector.to_a.join }.join("\n")
  end
  
end

if __FILE__ == $0
  setup = [ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_f]
  ticks = ARGV[3].to_i
  GameOfLife.new(*setup).go(ticks)
end
