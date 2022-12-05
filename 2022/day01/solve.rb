calories = File.read('input.txt')
               .split("\n\n")
               .map { |foods| foods.lines.map(&:to_i).sum }
               .sort
               .reverse

a = calories[0]
b = calories[0..2].sum

puts "a: #{a} (#{a == 71124})"
puts "b: #{b} (#{b == 204639})"
