class Decryptor
  Node = Struct.new(:number, :left, :right) do
    def move_right = self.class.swap(self, right)
    def move_left = self.class.swap(left, self)

    def self.swap(left, right)
      left.left.right, right.right.left = right, left
      left.left, left.right, right.right, right.left = right, right.right, left, left.left
    end
  end

  attr_accessor :nodes, :nodes_in_order, :zero_idx

  def initialize(*data)
    @zero_idx = data.index(0)
    @nodes = data.each_with_object([]) { |number, nodes| insert(number, nodes) }
    @nodes_in_order = Array.new(nodes).freeze
  end

  def insert(number, nodes)
    nodes << Node.new(number, nodes.last, nodes.first).tap do |node|
      nodes.last.right = nodes.first.left = node if nodes.any?
    end
  end

  def mix
    nodes_in_order.each do |node|
      num_moves = (node.number.abs % (nodes_in_order.size - 1))

      if node.number.positive?
        num_moves.times { node.move_right }
      elsif node.number.negative?
        num_moves.times { node.move_left }
      end
    end
  end

  def grove_coordinates_sum
    current = nodes_in_order[zero_idx]
    3.times.map { 1000.times { current = current.right }.then { current.number } }.sum
  end
end

def solve(encrypted, rounds)
  decryptor = Decryptor.new(*encrypted)
  rounds.times { decryptor.mix }
  decryptor.grove_coordinates_sum
end

encrypted = File.readlines('inputs/20.txt', chomp: true).map(&:to_i)

a = solve(encrypted, 1)
b = solve(encrypted.map{ _1 * 811_589_153 }, 10)

require 'minitest/autorun'

describe 'day 20' do
  it 'part a' do assert_equal 1_591, a end
  it 'part b' do assert_equal 14_579_387_544_492, b end
end
