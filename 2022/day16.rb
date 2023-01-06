require 'lazy_priority_queue'

def parse_valves
  scans = File.readlines('inputs/16.txt').map { |description| description.scan(/[A-Z]{2}|\d+/) }
  names = scans.map(&:first)
  start_idx = names.index('AA')
  valves = scans.map { |scan| [scan[0], scan[1].to_i, scan[2..].map { |neighbor| names.index(neighbor) }] }
  [valves, start_idx]
end

def distance_between_valves(valves)
  dist = Array.new(valves.size) { Array.new(valves.size, Float::INFINITY) }

  valves.each_with_index do |(_, _, neighbors), valve|
    neighbors.each { |neighbor| dist[valve][neighbor] = 1 }
    dist[valve][valve] = 0
  end

  valves.size.times do |k|
    valves.size.times do |i|
      valves.size.times do |j|
        dist[i][j] = dist[i][k] + dist[k][j] if dist[i][j] > dist[i][k] + dist[k][j]
      end
    end
  end

  dist
end

def flowing_valves(valves) = valves.each_with_index.filter_map { |valve, idx| idx if valve[1].positive? }

def estimate_total(state, valves)
  _, closed_flowing_valves, eventual_total_release, minute = state
  eventual_total_release + closed_flowing_valves.sum { |valve| valves[valve][1] * minute }
end

def move(current, minute, valve_to_open, eventual_total_release, closed_flowing_valves, valves, dist)
  valve_flow_rate = valves[valve_to_open][1]
  distance_to_valve = dist[current][valve_to_open]
  new_minute = minute - distance_to_valve - 1

  return if minute.negative?

  valve_eventual_total_release = new_minute * valve_flow_rate
  new_eventual_total_release = eventual_total_release + valve_eventual_total_release
  new_closed_flowing_valves = closed_flowing_valves - [valve_to_open]

  [valve_to_open, new_closed_flowing_valves, new_eventual_total_release, new_minute]
end

def moves(state, valves, dist)
  current, closed_flowing_valves, eventual_total_release, minute = state

  closed_flowing_valves.filter_map do |valve_to_open|
    move(current, minute, valve_to_open, eventual_total_release, closed_flowing_valves, valves, dist)
  end
end

def most_pressure_released(valves, start, minute, dist, closed_flowing_valves)
  queue = MaxPriorityQueue.new
  visited = Set.new

  state = [start, closed_flowing_valves, 0, minute]

  queue.push state, estimate_total(state, valves)
  visited << state
  max_released = 0

  while (current_state = queue.pop)
    max_released = current_state[2] if current_state[2] > max_released

    moves(current_state, valves, dist).each do |new_state|
      next if visited.include?(new_state)
      next if estimate_total(new_state, valves) <= max_released

      queue.push new_state, estimate_total(new_state, valves)
      visited << new_state
    end
  end

  max_released
end

def most_pressure_released_in_parallel(valves, start, dist, closed_flowing_valves)
  closed_flowing_valves.combination(closed_flowing_valves.size / 2).map do |my_valves|
    elephant_valves = closed_flowing_valves - my_valves

    me = most_pressure_released(valves, start, 26, dist, my_valves)
    elephant = most_pressure_released(valves, start, 26, dist, elephant_valves)

    me + elephant
  end.max
end

valves, start = parse_valves
dist = distance_between_valves(valves)
closed_flowing_valves = flowing_valves(valves)

a = most_pressure_released(valves, start, 30, dist, closed_flowing_valves)
b = most_pressure_released_in_parallel(valves, start, dist, closed_flowing_valves)

require 'minitest/autorun'

describe 'day 16' do
  it 'part a' do assert_equal 1_940, a end
  it 'part b' do assert_equal 2_469, b end
end
