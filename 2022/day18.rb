OFFSETS = [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]].freeze

cubes = File.readlines('inputs/18.txt').map { |line| line.split(',').map(&:to_i) }

def surface_area(cubes)
  sides = Set.new
  surface_area = 0

  cubes.each do |(x, y, z)|
    OFFSETS.each do |(dx, dy, dz)|
      side = [x + dx / 2.0, y + dy / 2.0, z + dz / 2.0]
      surface_area += sides.include?(side) ? -1 : 1
      sides << side
    end
  end

  surface_area
end

def exterior_surface_area(cubes)
  bounding_box = [cubes.map { _1[0] }.minmax, cubes.map { _1[1] }.minmax, cubes.map { _1[2] }.minmax]
  surface_area = 0
  start = [bounding_box[0][0], bounding_box[1][0], bounding_box[2][0]]
  queue = [start]
  visited = Set.new

  while (current = queue.pop)
    OFFSETS.each do |offset|
      next if visited.include?([current, offset])

      visited << [current, offset]

      neighbor = [current[0] + offset[0], current[1] + offset[1], current[2] + offset[2]]
      next if neighbor[0] < bounding_box[0][0] - 1 || neighbor[0] > bounding_box[0][1] + 1
      next if neighbor[1] < bounding_box[1][0] - 1 || neighbor[1] > bounding_box[1][1] + 1
      next if neighbor[2] < bounding_box[2][0] - 1 || neighbor[2] > bounding_box[2][1] + 1

      if cubes.include?(neighbor)
        surface_area += 1
      else
        queue.push neighbor
      end
    end
  end

  surface_area
end


a = surface_area(cubes)
b = exterior_surface_area(cubes)

require 'minitest/autorun'

describe 'day 18' do
  it 'part a' do assert_equal 4_500, a end
  it 'part b' do assert_equal 2_558, b end
end
