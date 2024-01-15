NEIGHBOR_DELTAS = [[0, -1], [1, 0], [0, 1], [-1, 0]].freeze
EXPANSIONS = 202300
NUM_ODD = EXPANSIONS + 1
NUM_EVEN = EXPANSIONS

@coords = Set.new

File.readlines('input.txt', chomp: true).each_with_index do |line, row|
  @dimension = line.size

  line.each_char.each_with_index do |c, col|
    next if c == '#'

    coord = [col, row]
    @start = coord if c == 'S'
    @coords << coord
  end
end

@steps = {}
@steps[@start] = 0

queue = [@start]

while elem = queue.shift
  NEIGHBOR_DELTAS.each do |(dx, dy)|
    coord = [elem[0] + dx, elem[1] + dy]
    next if @steps.key?(coord) || !@coords.include?(coord)

    @steps[coord] = @steps[elem] + 1
    queue.push(coord) 
  end
end

(even, odd) = @steps.values.partition(&:even?)

part_a = even.count {|v| v <= 64}
part_b = NUM_ODD**2 * odd.size + NUM_EVEN**2 * even.size - NUM_ODD * odd.count {|v|v > 65} + NUM_EVEN * even.count {|v|v > 65}

puts "part a: #{part_a}"
puts "part b: #{part_b}"
