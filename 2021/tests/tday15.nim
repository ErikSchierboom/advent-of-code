import day15, std/unittest

suite "day 15":
  test "part 1":
    let solution = solveDay15()
    check: 613 == solution.part1

  test "part 2":
    let solution = solveDay15()
    check: 2899 == solution.part2
