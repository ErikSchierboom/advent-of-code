require 'set'
require 'lazy_priority_queue'

Valley = Struct.new(:start, :goal, :blizzards, :width, :height)

EXPEDITION_DIRECTIONS = [[0,0], [1,0], [-1,0], [0,1], [0,-1]].freeze

def distance(from, to) = (to[0] - from[0]).abs + (to[1] - from[1]).abs

def priority(expedition, minute, goal) = minute + distance(expedition, goal)

def calculate_blizzards_per_minute(valley)
  Array.new(valley.width * valley.height) do |minute|
    valley.blizzards.each_with_object(Set.new) do |(direction, x, y), acc|
      case direction
      when '>' then acc << [(x + minute) % valley.width, y]
      when '<' then acc << [(x - minute) % valley.width, y]
      when 'v' then acc << [x, (y + minute) % valley.height]
      when '^' then acc << [x, (y - minute) % valley.height]
      end
    end
  end
end

def actions(expedition, start, goal, blizzards_per_minute, minute, valley)
  EXPEDITION_DIRECTIONS.filter_map do |direction|
    new_expedition = [expedition[0] + direction[0], expedition[1] + direction[1]]
    new_minute = minute + 1

    next [new_expedition, new_minute] if new_expedition == goal || new_expedition == start
    next if new_expedition[0].negative? || new_expedition[0] >= valley.width
    next if new_expedition[1].negative? || new_expedition[1] >= valley.height
    next if blizzards_per_minute[new_minute % (valley.width * valley.height)].include?(new_expedition)

    [new_expedition, new_minute]
  end
end

def fewest_number_of_minutes(start, goal, valley, blizzards_per_minute, minute)
  queue = MinPriorityQueue.new
  visited = Set.new

  queue.push [start, minute], priority(start, minute, goal)
  visited << [start, minute]

  while ((expedition, minute) = queue.pop)
    return minute if expedition == goal

    actions(expedition, start, goal, blizzards_per_minute, minute, valley).each do |(new_expedition,  new_minute)|
      next if visited.include?([new_expedition,  new_minute])

      visited << [new_expedition,  new_minute]
      queue.push [new_expedition,  new_minute], priority(new_expedition, new_minute, goal)
    end
  end
end

valley = File.readlines('inputs/24.txt', chomp: true).then do |lines|
  cells = lines[1..-2].map { |line| line[1..-2].chars }
  width = cells.first.size
  height = cells.size
  start = [lines.first.index('.') - 1, -1]
  goal = [lines.last.index('.') - 1, height]
  blizzards = []

  height.times do |y|
    width.times do |x|
      cell = cells[y][x]
      blizzards << [cell, x, y] if '<>^v'.include?(cell)
    end
  end

  Valley.new(start, goal, blizzards, width, height)
end

blizzards_per_minute = calculate_blizzards_per_minute(valley)

minutes_after_first_passage = fewest_number_of_minutes(valley.start, valley.goal, valley, blizzards_per_minute, 0)
minutes_after_second_passage = fewest_number_of_minutes(valley.goal, valley.start, valley, blizzards_per_minute, minutes_after_first_passage)
minutes_after_third_passage = fewest_number_of_minutes(valley.start, valley.goal, valley, blizzards_per_minute, minutes_after_second_passage)

a = minutes_after_first_passage
b = minutes_after_third_passage

require 'minitest/autorun'

describe 'day 24' do
  it 'part a' do assert_equal 255, a end
  it 'part b' do assert_equal 809, b end
end
