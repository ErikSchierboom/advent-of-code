class Monkey < Struct.new(:items, :worry_level, :throw_to)
  attr_reader :inspected_items

  def process(monkeys)
    @inspected_items ||= 0

    while items.any?
      adjusted_worry_level = worry_level.(items.shift)
      monkeys[throw_to.(adjusted_worry_level)].items.push(adjusted_worry_level)
      @inspected_items += 1
    end
  end
end

def monkey_business_level(rounds, adjust_worry_level)
  monkeys = File.read('inputs/11.txt',).split("\n\n").map(&:lines).map { |lines| lines.map { _1.scan(/[\w+*]+/) } }.map do |lines|
    items = lines[1][2..].map(&:to_i)
    worry_level = case lines[2][-2..]
      in ['*', 'old'] then -> { adjust_worry_level.(_1 * _1) }
      in ['+', value] then -> { adjust_worry_level.(_1 + value.to_i) }
      in ['*', value] then -> { adjust_worry_level.(_1 * value.to_i) }
    end
    throw_to = -> (worry_level) { (worry_level % lines[3].last.to_i).zero? ? lines[4].last.to_i : lines[5].last.to_i }

    Monkey.new(items, worry_level, throw_to)
  end

  rounds.times { monkeys.each { _1.process(monkeys) } }
  monkeys.map(&:inspected_items).sort.last(2).inject(&:*)
end

a = monkey_business_level(20, -> (worry_level) { worry_level / 3 })
b = monkey_business_level(10_000, -> (worry_level) { worry_level % 9_699_690 })

require 'minitest/autorun'

describe 'day 11' do
  it 'part a' do assert_equal 88_208, a end
  it 'part b' do assert_equal 21_115_867_968, b end
end
