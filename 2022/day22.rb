OFFSETS = [[1, 0], [0, 1], [-1, 0], [0, -1]].freeze
CUBE_OFFSETS = [[1, 0], [2, 0], [1, 1], [0, 2], [1, 2], [0, 3]].freeze
RIGHT = 0; DOWN = 1; LEFT = 2; UP = 3

Cube = Struct.new(:x, :y, :walls)

class FlatMoveStrategy
  def move(board)
    new_x, new_y = [board.position[0] + board.offset[0], board.position[1] + board.offset[1]]
    new_position = [new_x % board.cube_size, new_y % board.cube_size]

    if new_x.negative?
      [new_position, [nil, 2, 1, 3, 5, 4, 6][board.cube], board.facing]
    elsif new_x == board.cube_size
      [new_position, [nil, 2, 1, 3, 5, 4, 6][board.cube], board.facing]
    elsif new_y.negative?
      [new_position, [nil, 5, 2, 1, 6, 3, 4][board.cube], board.facing]
    elsif new_y == board.cube_size
      [new_position, [nil, 3, 2, 5, 6, 1, 4][board.cube], board.facing]
    else
      [new_position, board.cube, board.facing]
    end
  end
end

class CubeMoveStrategy
  def move(board)
    x, y = board.position
    new_x, new_y = [x + board.offset[0], y + board.offset[1]]

    if new_x.negative?
      case board.cube
      when 1 then [[0, board.cube_size - 1 - y], 4, RIGHT]
      when 2 then [[board.cube_size - 1, y],     1, LEFT]
      when 3 then [[y, 0],                       4, DOWN]
      when 4 then [[0, board.cube_size - 1 - y], 1, RIGHT]
      when 5 then [[board.cube_size - 1, y],     4, LEFT]
      when 6 then [[y, 0],                       1, DOWN]
      end
    elsif new_x == board.cube_size
      case board.cube
      when 1 then [[0, y],                                         2, RIGHT]
      when 2 then [[board.cube_size - 1, board.cube_size - 1 - y], 5, LEFT]
      when 3 then [[y, board.cube_size - 1],                       2, UP]
      when 4 then [[0, y],                                         5, RIGHT]
      when 5 then [[board.cube_size - 1, board.cube_size - 1 - y], 2, LEFT]
      when 6 then [[y, board.cube_size - 1],                       5, UP]
      end
    elsif new_y.negative?
      case board.cube
      when 1 then [[0, x],                   6, RIGHT]
      when 2 then [[x, board.cube_size - 1], 6, UP]
      when 3 then [[x, board.cube_size - 1], 1, UP]
      when 4 then [[0, x],                   3, RIGHT]
      when 5 then [[x, board.cube_size - 1], 3, UP]
      when 6 then [[x, board.cube_size - 1], 4, UP]
      end
    elsif new_y == board.cube_size
      case board.cube
      when 1 then [[x, 0],                   3, DOWN]
      when 2 then [[board.cube_size - 1, x], 3, LEFT]
      when 3 then [[x, 0],                   5, DOWN]
      when 4 then [[x, 0],                   6, DOWN]
      when 5 then [[board.cube_size - 1, x], 6, LEFT]
      when 6 then [[x, 0],                   2, DOWN]
      end
    else
      [[new_x, new_y], board.cube, board.facing]
    end
  end
end

class Board
  attr_reader :cubes, :cube_size, :cube, :position, :facing, :move_strategy

  def initialize(cubes, cube_size, move_strategy)
    @cubes = cubes
    @cube_size = cube_size
    @cube = 1
    @position = [0, 0]
    @facing = RIGHT
    @move_strategy = move_strategy
  end

  def self.parse(description, move_strategy)
    rows = description.lines(chomp: true).map(&:chars)

    cube_size = Math.sqrt(description.gsub(/ |\n/, '').size / 6).to_i
    cubes = CUBE_OFFSETS.map do |(dx, dy)|
      walls = cube_size.times.flat_map do |y|
        cube_size.times.filter_map do |x|
          [x, y] if rows[dy * cube_size + y][dx * cube_size + x] == '#'
        end
      end
      Cube.new(dx * cube_size, dy * cube_size, walls)
    end
    cubes.unshift(nil)

    Board.new(cubes, cube_size, move_strategy)
  end

  def offset = OFFSETS[facing]
  def turn_right = @facing = (facing + 1) % 4
  def turn_left = @facing = (facing - 1) % 4

  def move(num_steps)
    num_steps.times do
      new_position, new_cube, new_facing = move_strategy.move(self)
      break if cubes[new_cube].walls.include?(new_position)

      @position = new_position
      @cube = new_cube
      @facing = new_facing
    end
  end

  def password(instructions)
    instructions.each do |instruction|
      case instruction
      when 'R' then turn_right
      when 'L' then turn_left
      else move(instruction.to_i)
      end
    end

    1000 * (cubes[cube].y + position[1] + 1) + 4 * (cubes[cube].x + position[0] + 1) + facing
  end
end

def calculate_password(move_strategy)
  top, bottom = File.read('inputs/22.txt').split("\n\n")
  instructions = bottom.scan(/\d+|[RL]/)

  board = Board.parse(top, move_strategy)
  board.password(instructions)
end

a = calculate_password(FlatMoveStrategy.new)
b = calculate_password(CubeMoveStrategy.new)

require 'minitest/autorun'

describe 'day 22' do
  it 'part a' do assert_equal 76_332, a end
  it 'part b' do assert_equal 144_012, b end
end
