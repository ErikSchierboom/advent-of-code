registers = File.readlines('inputs/10.txt', chomp: true).inject([1]) do |history, instruction|
  case instruction.split(' ')
  in ['noop'] then history.push(history.last)
  in ['addx', value] then history.push(history.last).push(history.last + value.to_i)
  end
end

a = [20, 60, 100, 140, 180, 220].sum {|cycle| cycle * registers[cycle - 1] }
b = registers[0..-2].each_slice(40).map do|row|
  row.each_with_index.map {|register, col| (register - col).abs <= 1 ? "#" : '.' }.join + "\n"
end.join

require 'minitest/autorun'

expected_b = <<~B
####.####.###..####.#..#..##..#..#.###..
...#.#....#..#.#....#..#.#..#.#..#.#..#.
..#..###..###..###..####.#....#..#.#..#.
.#...#....#..#.#....#..#.#.##.#..#.###..
#....#....#..#.#....#..#.#..#.#..#.#....
####.#....###..#....#..#..###..##..#....
B

describe 'day 10' do
  it 'part a' do assert_equal 15_680, a end
  it 'part b' do assert_equal expected_b, b end
end
