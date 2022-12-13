require 'json'

class Array
  def <=>(right)
    case [self, right]
    in [[], []] then 0
    in [[], Array] then -1
    in [Array, []] then 1
    in [[Integer => a, *as], [Array => b, *bs]] then [[a], *as] <=> [b, *bs]
    in [[Array => a, *as], [Integer => b, *bs]] then [a, *as] <=> [[b], *bs]
    in [[a, *as], [b, *bs]] then
      head_comparison = a <=> b
      head_comparison.zero? ? as <=> bs : head_comparison
    end
  end
end

packets = File.readlines('inputs/13.txt', chomp: true).reject(&:empty?).map { JSON.parse(_1) }
divider_packets = [[[2]], [[6]]]

a = packets.each_slice(2).with_index(1).sum { |pair, idx| pair == pair.sort ? idx : 0 }
b = packets.push(*divider_packets).sort.then { |sorted_packets| divider_packets.map { sorted_packets.index(_1) + 1 }.inject(:*) }

require 'minitest/autorun'

describe 'day 13' do
  it 'part a' do assert_equal 5_806, a end
  it 'part b' do assert_equal 23_600, b end
end
