import day13, unittest, std/strutils

suite "day 13":
  test "part 1":
    let solution = solveDay13()
    check: 704 == solution.part1

  test "part 2":
    let solution = solveDay13()
    let expected =
      """
      #..#..##...##....##.###..####.#..#..##.
      #..#.#..#.#..#....#.#..#.#....#..#.#..#
      ####.#....#..#....#.###..###..####.#...
      #..#.#.##.####....#.#..#.#....#..#.#...
      #..#.#..#.#..#.#..#.#..#.#....#..#.#..#
      #..#..###.#..#..##..###..####.#..#..##.
      """.unindent
    check: expected == solution.part2
