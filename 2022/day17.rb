require 'sorted_set'

EMPTY  = 0b00000000
BOTTOM = 0b01111111
RIGHT  = 0b00000001
LEFT   = 0b01000000

JET_PATTERN = File.read('inputs/17.txt').chars.freeze
ROCKS = [
  [0b00011110],
  [0b00001000,
   0b00011100,
   0b00001000],
  [0b00000100,
   0b00000100,
   0b00011100],
  [0b00010000,
   0b00010000,
   0b00010000,
   0b00010000],
  [0b00011000,
   0b00011000]
].freeze

def simulate(num_times)
  layers = [BOTTOM]
  rock_idx = jet_pattern_idx = height_offset = 0
  cache = Hash.new

  while rock_idx < num_times do
    rock = ROCKS[rock_idx % ROCKS.size].dup
    layers.push(*Array.new(3 + rock.size, EMPTY))

    (layers.size - 1).downto(1) do |y|
      jet = JET_PATTERN[jet_pattern_idx % JET_PATTERN.size]

      if jet == '>' && rock.each_with_index.all? { |stone, dy| (stone & RIGHT) != RIGHT && (stone >> 1 & layers[y - dy]).zero? }
        rock.each_index { |dy| rock[dy] >>= 1 }
      elsif jet == '<' && rock.each_with_index.all? { |stone, dy| (stone & LEFT) != LEFT && (stone << 1 & layers[y - dy]).zero? }
        rock.each_index { |dy| rock[dy] <<= 1 }
      end

      jet_pattern_idx += 1

      next unless rock.each_with_index.any? { |stone, dy| (layers[y - dy - 1] & stone).positive? }
      rock.each_with_index { |stone, dy| layers[y - dy] |= stone }
      layers.pop(layers.reverse.count(&:zero?))
      break
    end

    key = [rock_idx % ROCKS.size, jet_pattern_idx % JET_PATTERN.size, layers[-2..]]

    if cache.key?(key)
      old_rock_idx, old_height = cache[key]
      d_height = layers.size - old_height
      d_rocks = rock_idx - old_rock_idx

      num_remaining_rocks = num_times - rock_idx
      num_remaining_cycles = num_remaining_rocks / d_rocks
      rock_idx += num_remaining_cycles * d_rocks
      height_offset += d_height * num_remaining_cycles
    end

    cache[key] = [rock_idx, layers.size]
    rock_idx += 1
  end

  layers.size + height_offset  - 1
end

a = simulate(2_022)
b = simulate(1_000_000_000_000)

require 'minitest/autorun'

describe 'day 17' do
  it 'part a' do assert_equal 3_188, a end
  it 'part b' do assert_equal 1_591_977_077_342, b end
end
