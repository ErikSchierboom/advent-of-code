import day22, std/unittest

suite "day 22":
  test "part 1":
    let solution = solveDay22()
    check: 587785 == solution.part1

  test "part 2":
    let solution = solveDay22()
    check: 1167985679908143 == solution.part2
