require 'set'

grid = File.readlines('inputs/08.txt', chomp: true).map { |line| line.chars.map(&:to_i) }
transposed_grid = grid.transpose

visible = Set.new
max_heights = Array.new(4) { Array.new(grid.size, -1) }
max_scenic_score = 0

grid.size.times do |row|
  grid.size.times do |col|
    if col.positive? && row.positive? && col < grid.size - 1 && row < grid.size - 1
      view_lines = [grid[row][0..col-1].reverse, grid[row][col+1..], transposed_grid[col][row+1..], transposed_grid[col][0..row-1].reverse]
      scenic_score = view_lines.map {|heights| heights.find_index { |height| height >= grid[row][col] }&.succ || heights.size}.inject(:*)
      max_scenic_score = scenic_score if scenic_score > max_scenic_score
    end

    if grid[row][col] > max_heights[0][row]
      visible << [row, col]
      max_heights[0][row] = grid[row][col]
    end

    if grid[row][col] > max_heights[1][col]
      visible << [row, col]
      max_heights[1][col] = grid[row][col]
    end

    if grid[row][grid.size - col - 1] > max_heights[2][row]
      visible << [row, grid.size - col - 1]
      max_heights[2][row] = grid[row][grid.size - col - 1]
    end

    if grid[grid.size - row - 1][col] > max_heights[3][col]
      visible << [grid.size - row - 1, col]
      max_heights[3][col] = grid[grid.size - row - 1][col]
    end
  end
end

a = visible.size
b = max_scenic_score

require 'minitest/autorun'

describe 'day 08' do
  it 'part a' do assert_equal 1_794, a end
  it 'part b' do assert_equal 199_272, b end
end
