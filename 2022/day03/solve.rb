PRIORITIES = [nil, *'a'..'z', *'A'..'Z'].freeze

def priority(item_types) = PRIORITIES.index(item_types.map(&:chars).reduce(:&).first)

rucksacks = File.readlines('input.txt', chomp: true)
a = rucksacks.sum { |rucksack| priority(rucksack.partition(/.{#{rucksack.size/2}}/)[1..]) }
b = rucksacks.each_slice(3).sum { |group| priority(group) }

puts "a: #{a} (#{a == 7_737})"
puts "b: #{b} (#{b == 2_697})"
