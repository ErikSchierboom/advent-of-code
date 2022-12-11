class Monkey < Struct.new(:items, :worry_level_for_item, :divisor_for_primary, :primary_target, :secondary_target)
  attr_reader :inspected_items

  def process_items(monkeys, correct_worry_level)
    @inspected_items ||= 0

    while items.any?
      worry_level = correct_worry_level.call(worry_level_for_item.call(items.shift))
      target = (worry_level % divisor_for_primary).zero? ? primary_target : secondary_target
      monkeys[target].items.push(worry_level)
      @inspected_items += 1
    end
  end
end

def monkey_business_level(rounds, correct_worry_level)
  monkeys = File.read('inputs/11.txt',).split("\n\n").map(&:lines).map { |lines| lines.map { _1.scan(/[\w+*]+/) } }.map do |lines|
    items = lines[1][2..].map(&:to_i)
    worry_level = case lines[2][-2..]
      in ['*', 'old'] then -> { _1 * _1 }
      in ['+', value] then -> { _1 + value.to_i }
      in ['*', value] then -> { _1 * value.to_i }
    end
    Monkey.new(items, worry_level, *lines[3..5].map(&:last).map(&:to_i))
  end

  divisor_product = monkeys.map(&:divisor_for_primary).inject(&:*)
  correct_worry_level = correct_worry_level.call(divisor_product)

  rounds.times { monkeys.each { _1.process_items(monkeys, correct_worry_level) } }
  monkeys.map(&:inspected_items).sort.last(2).inject(&:*)
end

a = monkey_business_level(20, -> _ { -> { _1 / 3 } })
b = monkey_business_level(10_000, -> (divisor_product) { -> { _1 % divisor_product } })

require 'minitest/autorun'

describe 'day 11' do
  it 'part a' do assert_equal 88_208, a end
  it 'part b' do assert_equal 21_115_867_968, b end
end
