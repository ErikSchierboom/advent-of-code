score_a = %w[nil BX CY AZ AX BY CZ CX AY BZ]
score_b = %w[nil BX CX AX AY BY CY CZ AZ BZ]

instructions = File.readlines('inputs/02.txt', chomp: true).map { |instruction| instruction.delete(' ') }

a = instructions.sum { |instruction| score_a.index(instruction) }
b = instructions.sum { |instruction| score_b.index(instruction) }

require 'minitest/autorun'

describe 'day 02' do
  it 'part a' do _(a).must_equal 11_873 end
  it 'part b' do _(b).must_equal 12_014 end
end
