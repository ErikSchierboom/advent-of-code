calories = File.read('inputs/01.txt')
               .split("\n\n")
               .map { |foods| foods.lines.map(&:to_i).sum }
               .sort
               .reverse

a = calories[0]
b = calories[0..2].sum

require 'minitest/autorun'

describe 'day 01' do
  it 'part a' do _(a).must_equal 71_124 end
  it 'part b' do _(b).must_equal 204_639 end
end
