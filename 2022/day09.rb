require 'set'

def num_visited(num_knots)
  knots = Array.new(num_knots) { [0, 0] }
  visited = Set.new([knots.last.dup])

  moves = File.readlines('inputs/09.txt', chomp: true).map { |line| line.split(' ').then { [_1, _2.to_i] } }
  moves.each do |move, distance|
    distance.times do
      case move
      when 'R' then knots[0][0] += 1
      when 'L' then knots[0][0] -= 1
      when 'U' then knots[0][1] += 1
      when 'D' then knots[0][1] -= 1
      end

      knots.each_cons(2) do |leader, follower|
        if (leader[1] - follower[1]).abs > 1 || (leader[0] - follower[0]).abs > 1
          follower[0] += leader[0] <=> follower[0]
          follower[1] += leader[1] <=> follower[1]
        end
      end

      visited << knots.last.dup
    end
  end

  visited.size
end

a = num_visited(2)
b = num_visited(10)

require 'minitest/autorun'

describe 'day 09' do
  it 'part a' do assert_equal 6_023, a end
  it 'part b' do assert_equal 2_533, b end
end
