def parse_stack_and_moves
  File.read('input.txt').then do |str|
    str.split("\n\n").then do |top, bottom|
      stacks = top.lines[0..-2]
                  .map { |line| line.scan(/\[(.)\](?: |$)| ( ) (?: |$)/).map(&:first) }
                  .transpose
                  .map(&:compact)
                  .map(&:reverse)
      moves = bottom.scan(/^move (\d+) from (\d+) to (\d+)$/).map { |move| move.map(&:to_i) }
      [stacks, moves]
    end
  end
end

def a_strategy(stacks, count, from, to) = stacks[to].push(*stacks[from].slice!(-count..).reverse)
def b_strategy(stacks, count, from, to) = stacks[to].push(*stacks[from].slice!(-count..))

def solve(strategy)
  stacks, moves = parse_stack_and_moves()
  moves.each { |move| strategy.call(stacks, move[0], move[1] - 1, move[2] - 1) }
  stacks.map(&:last).join
end

a = solve(method(:a_strategy))
b = solve(method(:b_strategy))

puts "a: #{a} (#{a == 'SVFDLGLWV'})"
puts "b: #{b} (#{b == 'DCVTCVPCL'})"
