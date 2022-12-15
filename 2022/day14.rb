require 'set'

POUR_POINT = [500, 0].freeze

def simulate(end_condition)
  cave = File.readlines('inputs/14.txt', chomp: true).each_with_object(Set.new) do |path, cave|
    path.scan(/(\d+),(\d+)/).map { _1.map(&:to_i) }.each_cons(2).map(&:sort).each do |(from, to)|
      cave.merge(from[0].upto(to[0]).to_a.product(from[1].upto(to[1]).to_a))
    end
  end

  bottom = cave.map(&:last).max
  num_rocks = cave.size

  loop do
    sand = POUR_POINT

    loop do
      break if sand[1] == bottom + 1

      if !cave.include?([sand[0], sand[1] + 1])
        sand[1] += 1
      elsif !cave.include?([sand[0] - 1, sand[1] + 1])
        sand[0] -= 1
        sand[1] += 1
      elsif !cave.include?([sand[0] + 1, sand[1] + 1])
        sand[0] += 1
        sand[1] += 1
      else
        break
      end
    end

    cave << sand
    return cave.size - num_rocks if end_condition.call(sand[1] == bottom + 1, sand == POUR_POINT)
  end
end

a = simulate(->(on_bottom, _on_top) { on_bottom }) - 1
b = simulate(->(_on_bottom, on_top) { on_top })

require 'minitest/autorun'

describe 'day 14' do
  it 'part a' do assert_equal 692, a end
  it 'part b' do assert_equal 31_706, b end
end
