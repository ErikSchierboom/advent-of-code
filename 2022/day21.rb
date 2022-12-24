monkeys = File.readlines('inputs/21.txt', chomp: true).to_h { _1.split(': ') }.transform_values(&:split)

def analyze(name, monkeys, yelled, parents)
  monkey = monkeys[name]

  yelled_number =
    case monkey
    in [number] then number.to_i
    in [first, '+', second] then analyze(first, monkeys, yelled, parents) + analyze(second, monkeys, yelled, parents)
    in [first, '-', second] then analyze(first, monkeys, yelled, parents) - analyze(second, monkeys, yelled, parents)
    in [first, '*', second] then analyze(first, monkeys, yelled, parents) * analyze(second, monkeys, yelled, parents)
    in [first, '/', second] then analyze(first, monkeys, yelled, parents) / analyze(second, monkeys, yelled, parents)
    end

  parents[monkey.first] = parents[monkey.last] = name if monkey.size == 3
  yelled.store(name, yelled_number)
end

def path_to_humn(parents)
  path = []
  current = 'humn'

  while current != 'root'
    path << current
    current = parents[current]
  end

  path.push('root')
end

def solve(monkeys, yelled, parents)
  humn_path = path_to_humn(parents)
  value = nil

  while (name = humn_path.pop)
    return value.to_i if name == 'humn'

    left, operator, right = monkeys[name]
    humn_in_left_path = left == humn_path.last
    value_in_other_path = yelled[humn_in_left_path ? right : left]

    value = value_in_other_path if name == 'root'
    next if name == 'root'

    case operator
    in '+' then value -= value_in_other_path
    in '-' if humn_in_left_path then value += value_in_other_path
    in '-' then value = value_in_other_path - value
    in '*' then value /= value_in_other_path
    in '/' then value *= value_in_other_path
    end
  end
end

yelled = {}
parents = {}
analyze('root', monkeys, yelled, parents)

a = yelled['root']
b = solve(monkeys, yelled, parents)

require 'minitest/autorun'

describe 'day 21' do
  it 'part a' do assert_equal 104_272_990_112_064, a end
  it 'part b' do assert_equal 3_220_993_874_133, b end
end
