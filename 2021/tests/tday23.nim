import day23, std/unittest

suite "day 23":
  # test "part 1":
  #   let solution = solveDay23()
  #   check: 679329 == solution.part1

  # test "part 2":
  #   let solution = solveDay23()
  #   check: 433315766324816 == solution.part2

  test "hallway 0 to 1":
    check: 1 == movesBetween(0, 1)

  test "hallway 0 to 4":
    check: 3 == movesBetween(0, 4)

  test "hallway 0 to 7":
    check: 5 == movesBetween(0, 7)

  test "hallway 0 to 10":
    check: 7 == movesBetween(0, 10)

  test "hallway 0 to 13":
    check: 9 == movesBetween(0, 13)

  test "hallway 0 to 14":
    check: 10 == movesBetween(0, 14)

  test "hallway 4 to 13":
    check: 6 == movesBetween(4, 13)

# 0 1 4 7 10 13 14
#    2 5 8 11
#    3 6 9 12