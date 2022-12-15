require 'set'

def manhattan_distance((x1, y1), (x2, y2)) = (x1 - x2).abs + (y1 - y2).abs

def merge_ranges(ranges)
  merged_ranges = []
  ranges.sort!

  lower, upper = ranges[0]
  ranges[1..].each do |range|
    if range[0] <= upper
      upper = [range[1], upper].max
    else
      merged_ranges << [lower, upper]
      lower, upper = range
    end
  end

  merged_ranges << [lower, upper]
  merged_ranges
end

Reading = Struct.new(:sensor, :beacon, :distance) do
  def num_occupied(y)
    dy = (sensor[1] - y).abs
    [sensor[0] - (distance - dy), sensor[0] + (distance - dy)] if dy <= distance
  end
end

readings = File.readlines('inputs/15.txt', chomp: true).map do |line|
  sensor, beacon = line.scan(/-?\d+/).map(&:to_i).each_slice(2).to_a
  Reading.new(sensor, beacon, manhattan_distance(sensor, beacon))
end

TARGET_ROW = 2_000_000
num_occupied = merge_ranges(readings.filter_map { _1.num_occupied(TARGET_ROW) }).sum { (_1[0] - _1[1]).abs } + 1
num_beacons = readings.filter_map { _1.beacon[0] if _1.beacon[1] == TARGET_ROW }.to_set.count
a = num_occupied - num_beacons

TUNING_GRID_SIZE = 4_000_000
b = TUNING_GRID_SIZE.times do |y|
  ranges = merge_ranges(readings.filter_map { _1.num_occupied(y) })
  break (ranges[0][1] + 1) * TUNING_GRID_SIZE + y if ranges.size > 1
end

require 'minitest/autorun'

describe 'day 15' do
  it 'part a' do assert_equal 4_886_370, a end
  it 'part b' do assert_equal 11_374_534_948_438, b end
end
