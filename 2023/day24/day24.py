# Adapted from https://github.com/mgtezak/Advent_of_Code/blob/master/2023/Day_24.py

from itertools import combinations
from sympy import solve, symbols, Eq

with open('input.txt', 'r') as f:
    hailstones = [tuple(map(int, line.replace('@', ',').split(','))) for line in f.read().splitlines()]

lo = 200_000_000_000_000
hi = 400_000_000_000_000

def intersect(h1, h2):
    x1, y1, _, dx1, dy1, _ = h1
    x2, y2, _, dx2, dy2, _ = h2
    m1, m2 = dy1/dx1, dy2/dx2
    if m1 == m2: return False
    b1, b2 = y1 - m1*x1, y2 - m2*x2
    x = (b2 - b1) / (m1 - m2)
    y = m1*x + b1
    return lo <= x <= hi and lo <= y <= hi and ((x > x1) == (dx1 > 0)) and ((x > x2) == (dx2 > 0))

def part_a(hailstones):
    return sum(intersect(h1, h2) for h1, h2 in combinations(hailstones, 2))

def part_b(hailstones):
    variables = symbols('x y z dx dy dz t1 t2 t3')
    x, y, z, dx, dy, dz, *time = variables

    equations = []
    for t, (hx, hy, hz, hdx, hdy, hdz) in zip(time, hailstones[:3]):
        equations.append(Eq(x + t*dx, hx + t*hdx))
        equations.append(Eq(y + t*dy, hy + t*hdy))
        equations.append(Eq(z + t*dz, hz + t*hdz))

    return sum(solve(equations, variables).pop()[:3])

print('part a:', part_a(hailstones))
print('part b:', part_b(hailstones))
