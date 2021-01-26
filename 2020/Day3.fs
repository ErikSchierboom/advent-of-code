module AdventOfCode.Day3

let lines = Input.asLines 3
let rows = lines.Length
let cols = lines.[0].Length

let treeCount (dx, dy) =
    let rec inner (x, y) count =
        if y >= rows then
            count
        else
            inner (x + dx, y + dy) (if lines.[y % rows].[x % cols] = '#' then count + 1 else count)
    
    inner (0, 0) 0

let part1 = treeCount (3, 1)

let part2 =
    [ treeCount (1, 1)
      treeCount (3, 1)
      treeCount (5, 1)
      treeCount (7, 1)
      treeCount (1, 2) ]
    |> Seq.reduce (*)

let solution = part1, part2
