MOVES = [
  [[ 0,-1], [[-1,-1], [ 0,-1], [ 1,-1]]],
  [[ 0, 1], [[-1, 1], [ 0, 1], [ 1, 1]]],
  [[-1, 0], [[-1, 0], [-1,-1], [-1, 1]]],
  [[ 1, 0], [[ 1, 0], [ 1,-1], [ 1, 1]]],
].freeze

def proposed_move(elf, elves, rotate_by)
  MOVES.rotate(rotate_by)
       .filter_map { |(move, neighbors)| move if neighbors.none? { |(dx, dy)| elves.include?([elf[0] + dx, elf[1] + dy]) }}
       .then { |moves| [elf[0] + moves[0][0], elf[1] + moves[0][1]] unless moves.empty? || moves.size == MOVES.size }
end

def parse_elves
  File.readlines('inputs/23.txt', chomp: true).each_with_index.each_with_object(Set.new) do |(row, y), elves|
    row.chars.each_with_index.filter_map { |col, x| elves << [x, y] if col == '#' }
  end
end

def simulate(stop)
  elves = parse_elves
  round = 0

  loop do
    moves = elves.group_by { |elf| proposed_move(elf, elves, round % MOVES.size) }
    moves.compact.each do |move, moving_elves|
      next unless moving_elves.size == 1

      elves.delete(moving_elves[0])
      elves << move
    end

    round += 1
    break [round, elves] if stop.call(round, moves)
  end
end

def unoccupied(elves) = elves.map(&:first).minmax.inject(&:upto).size * elves.map(&:last).minmax.inject(&:upto).size - elves.size

a = simulate(->(round, _) { round == 10 }).last.then { unoccupied(_1) }
b = simulate(->(_, moves) { moves.keys.all?(&:nil?) }).first

require 'minitest/autorun'

describe 'day 23' do
  it 'part a' do assert_equal 3_862, a end
  it 'part b' do assert_equal 913, b end
end
