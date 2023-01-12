require 'lazy_priority_queue'

blueprints = File.readlines('inputs/19.txt').map do |line|
  numbers = line.scan(/\d+/).map(&:to_i)
  resources = [
    [numbers[1],          0, 0,          0],
    [numbers[2],          0, 0,          0],
    [numbers[3], numbers[4], 0,          0],
    [numbers[5],          0, numbers[6], 0],
  ]

  max_resources = [[numbers[1], numbers[2], numbers[3], numbers[5]].max, numbers[4], numbers[6], Float::INFINITY]
  [resources, max_resources]
end

def potential_max_geodes(state) = state[8] * state[7] + state[3] + ((state[8] - 1) * state[8]) / 2

def priority(state) = potential_max_geodes(state)

def moves(state, blueprint)
  return [] if state[8].zero?

  if state[8] == 1 # Any robot that is produced has no time left to contribute
    new_state = state.dup
    4.times { |idx| new_state[idx] += state[4 + idx] }
    new_state[8] = 0
    return [new_state]
  end

  new_moves = []

  4.times do |resource|
    # Already have enough robots to produce maximum amount of this resource
    next if state[4 + resource] >= blueprint[1][resource]

    # Required resource without any robot to produce it
    next if blueprint[0][resource].each_with_index.any? { |robot_resource, robot_resource_idx| robot_resource.positive? && state[4 + robot_resource_idx].zero? }

    minutes_to_produce = blueprint[0][resource].each_with_index.map do |robot_resource, robot_resource_idx|
      next 1 if state[robot_resource_idx] >= robot_resource

      (robot_resource - state[robot_resource_idx]).fdiv(state[4 + robot_resource_idx]).ceil + 1
    end.max

    new_minutes = state[8] - minutes_to_produce

    # Robot can't build _and_ produce a resource in remaining minutes
    next if new_minutes < 1

    new_state = state.dup
    4.times do |idx|
      new_state[idx] += minutes_to_produce * state[4 + idx]
      new_state[idx] -= blueprint[0][resource][idx]
    end
    new_state[4 + resource] += 1
    new_state[8] = new_minutes
    new_moves << new_state
  end

  new_moves
end

def max_geodes(blueprint, num_minutes)
  initial_state = [0, 0, 0, 0, 1, 0, 0, 0, num_minutes]
  max_cracked = 0

  queue = MaxPriorityQueue.new
  queue.push initial_state, priority(initial_state)

  visited = Set.new
  visited << initial_state

  while (state = queue.pop)
    moves(state, blueprint).each do |new_state|
      next if visited.include?(new_state)
      next if potential_max_geodes(new_state) <= max_cracked

      queue.push new_state, priority(new_state)
      visited << new_state
      max_cracked = new_state[3] if new_state[3] > max_cracked
    end
  end

  max_cracked
end

a = blueprints.each.with_index(1).sum { |blueprint, id| max_geodes(blueprint, 24) * id}
b = blueprints[0..2].map { |blueprint| max_geodes(blueprint, 32) }.inject(&:*)

require 'minitest/autorun'

describe 'day 19' do
  it 'part a' do assert_equal 1_616, a end
  it 'part b' do assert_equal 8_990, b end
end
