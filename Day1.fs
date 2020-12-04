module AdventOfCode.Day1

let numbers = Input.forDay 1 |> Array.map int

let part1 =
    [ for n1 in numbers do
        for n2 in numbers do
            if n1 + n2 = 2020 then yield n1 * n2 ]
    |> List.head

let part2 =
    [ for n1 in numbers do
        for n2 in numbers do
            for n3 in numbers do
                if n1 + n2 + n3 = 2020 then yield n1 * n2 * n3 ]
    |> List.head

let solution = part1, part2
    