filesystem = Hash.new(0)
current_path = ['/']

File.readlines('inputs/07.txt', chomp: true).each do |line|
  case line.split
  in ['$', 'cd', '/']
    current_path = ['/']
  in ['$', 'cd', '..']
    current_path.pop
  in ['$', 'cd', dir]
    current_path.push(dir)
  in [filesize, *] if filesize =~ /\d+/
    path = current_path.dup

    while path.any?
      filesystem[path.join('/')] += filesize.to_i
      path.pop
    end
  else
    next
  end
end

a = filesystem.values.select { |size| size <= 100_000 }.sum
b = filesystem.values.select { |size| 70_000_000 - filesystem['/'] + size >= 30_000_000 }.min

require 'minitest/autorun'

describe 'day 07' do
  it 'part a' do assert_equal 1_390_824, a end
  it 'part b' do assert_equal 7_490_863, b end
end
