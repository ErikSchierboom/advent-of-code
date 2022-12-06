def marker(size) = File.read('inputs/06.txt').chars.each_cons(size).find_index { |chars| chars.uniq.size == size } + size

a = marker(4)
b = marker(14)

require 'minitest/autorun'

describe 'day 06' do
  it 'part a' do assert_equal 1760, a end
  it 'part b' do assert_equal 2974, b end
end
