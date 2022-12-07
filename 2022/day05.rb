def parse_stack_and_moves
  File.readlines('inputs/05.txt', chomp: true)
      .then { |lines| lines.slice_when { |line| line.empty? }.to_a }
      .then do |(top, bottom)|
        stacks = top[0..-4].map { |line| (1..33).step(4).map { |idx| line.chars[idx] unless line.chars[idx] == ' ' } }
                           .transpose
                           .map(&:compact)
                           .map(&:reverse)
  moves = bottom.map { |line| line.scan(/^move (\d+) from (\d+) to (\d+)$/).flatten.map(&:to_i) }
        [stacks, moves]
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

require 'minitest/autorun'

describe 'day 05' do
  it 'part a' do assert_equal 'SVFDLGLWV', a end
  it 'part b' do assert_equal 'DCVTCVPCL', b end
end
