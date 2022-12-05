score_a = %w[nil BX CY AZ AX BY CZ CX AY BZ]
score_b = %w[nil BX CX AX AY BY CY CZ AZ BZ]

instructions = File.readlines('input.txt', chomp: true).map { |instruction| instruction.delete(' ') }

a = instructions.sum { |instruction| score_a.index(instruction) }
b = instructions.sum { |instruction| score_b.index(instruction) }

puts "a: #{a} (#{a == 11_873})"
puts "b: #{b} (#{b == 12_014})"
