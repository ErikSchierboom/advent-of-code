class String
  def to_decimal = chars.inject(0) { |decimal, digit| decimal * 5 + '=-012'.index(digit) - 2 }
end

class Integer
  def to_snafu
    snafu = ''
    total = self    
    
    loop do
      remainder = total % 5
      total /= 5

      if remainder <= 2
        snafu += remainder.to_s
      else
        snafu += '   -='[remainder]
        total += 1
      end

      break snafu.reverse if total.zero?
    end
  end
end

fuel_requirements = File.readlines('inputs/25.txt', chomp: true)
a = fuel_requirements.sum(&:to_decimal).to_snafu
b = 0

require 'minitest/autorun'

describe 'day 25' do
  it 'part a' do assert_equal '20=022=21--=2--12=-2', a end
  it 'part b' do assert_equal 0, b end
end
