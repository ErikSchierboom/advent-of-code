PRIORITIES = [nil, *'a'..'z', *'A'..'Z'].freeze

def priority(item_types) = PRIORITIES.index(item_types.map(&:chars).reduce(:&).first)

rucksacks = File.readlines('input.txt', chomp: true)
a = rucksacks.sum { |rucksack| priority(rucksack.partition(/.{#{rucksack.size/2}}/)[1..]) }
b = rucksacks.each_slice(3).sum { |group| priority(group) }

require 'minitest/autorun'

describe 'day 03' do
  it 'part a' do _(a).must_equal 7_737 end
  it 'part b' do _(b).must_equal 2_697 end
end
