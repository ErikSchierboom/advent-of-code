require 'lazy_priority_queue'

grid = File.readlines('inputs/12.txt', chomp: true).each_with_index.inject({}) do|grid, (cols, row)|
  grid.tap {cols.chars.each_with_index { |height, col| grid[[row, col]] = height.ord } }
end

start_coord = grid.key('S'.ord)
goal_coord  = grid.key('E'.ord)

grid[start_coord] = 'a'.ord
grid[goal_coord] = 'z'.ord

def neighbors(coord, steps, grid)
  [[-1, 0], [1, 0], [0, -1], [0, 1]].filter_map do |dy, dx|
    neighbor = [coord[0] + dy, coord[1] + dx]
    [neighbor, steps + 1] if grid.key?(neighbor) && grid[neighbor] - grid[coord] <= 1
  end
end

def fewest_steps(grid, goal_coord, start_coords)
  queue = MinPriorityQueue.new
  min_steps = Hash.new(Float::INFINITY)

  start_coords.each do |coord|
    queue.push [coord, 0], 0
    min_steps[coord] = 0
  end

  while ((coord, steps) = queue.pop)
    return min_steps[goal_coord] if coord == goal_coord

    neighbors(coord, steps, grid).each do |neighbor, neighbor_steps|
    if neighbor_steps < min_steps[neighbor]
        min_steps[neighbor] = neighbor_steps
        queue.push [neighbor, neighbor_steps], neighbor_steps
      end
    end
  end
end

a = fewest_steps(grid, goal_coord, [start_coord])
b = fewest_steps(grid, goal_coord, grid.filter_map {|coord, height| coord if height == 'a'.ord })

require 'minitest/autorun'

describe 'day 12' do
  it 'part a' do assert_equal 468, a end
  it 'part b' do assert_equal 459, b end
end
