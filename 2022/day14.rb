require 'set'

def parse_cave
  File.readlines('inputs/14.txt', chomp: true).each_with_object(Set.new) do |path, cave|
    path.scan(/(\d+),(\d+)/).map { _1.map(&:to_i) }.each_cons(2).map(&:sort).each do |(from, to)|
      cave.merge(from[0].upto(to[0]).to_a.product(from[1].upto(to[1]).to_a))
    end
  end
end

POUR_POINT = [500, 0].freeze
POUR_DIRECTIONS = [[0, 1], [-1, 1], [1, 1]].freeze

def simulate(end_condition)
  cave = parse_cave
  bottom = cave.map(&:last).max
  num_rocks = cave.size

  while true
    sand = POUR_POINT.dup

    while true
      break if sand[1] == bottom + 1
      break unless POUR_DIRECTIONS.map {|(dx, dy)| [sand[0] + dx, sand[1] + dy] }.find { !cave.include?(_1) }&.tap { sand = _1 }
    end

    cave << sand
    return cave.size - num_rocks if end_condition.call(sand[1] == bottom + 1, sand == POUR_POINT)
  end
end

a = simulate(-> (on_bottom, _on_top) { on_bottom }) - 1
b = simulate(-> (_on_bottom, on_top) { on_top })

require 'minitest/autorun'

describe 'day 14' do
  it 'part a' do assert_equal 692, a end
  it 'part b' do assert_equal 31_706, b end
end
