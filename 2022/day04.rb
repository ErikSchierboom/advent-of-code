def contains(fst, snd) = fst[0] >= snd[0] && fst[1] <= snd[1]
def overlaps(fst, snd) = fst[0] >= snd[0] && fst[0] <= snd[1] || fst[1] >= snd[0] && fst[1] <= snd[1]

pairs = File.readlines('inputs/04.txt', chomp: true).map { |line| line.split(',').map { |assignment| assignment.split('-').map(&:to_i) } }
a = pairs.count { |fst, snd| contains(fst, snd) || contains(snd, fst) }
b = pairs.count { |fst, snd| overlaps(fst, snd) || overlaps(snd, fst) }

require 'minitest/autorun'

describe 'day 04' do
  it 'part a' do _(a).must_equal 518 end
  it 'part b' do _(b).must_equal 909 end
end
