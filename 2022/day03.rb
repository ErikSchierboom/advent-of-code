PRIORITIES = [nil, *'a'..'z', *'A'..'Z'].freeze

def priority(item_types) = PRIORITIES.index(item_types.map(&:chars).reduce(:&).first)

rucksacks = File.readlines('inputs/03.txt', chomp: true)
a = rucksacks.sum { |rucksack| priority(rucksack.partition(/.{#{rucksack.size/2}}/)[1..]) }
b = rucksacks.each_slice(3).sum { |group| priority(group) }

require 'minitest/autorun'

describe 'day 03' do
  it 'part a' do assert_equal 7_737, a end
  it 'part b' do assert_equal 2_697, b end
end
