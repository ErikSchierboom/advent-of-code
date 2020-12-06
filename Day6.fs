module AdventOfCode.Day6

module String =
    let split (separator: string) (str: string) = str.Split(separator) 

let groupAnswers combiner =
    Input.asString 6
    |> String.split "\n\n"
    |> Seq.map (String.split "\n" >> Seq.map set)
    |> Seq.sumBy (Seq.reduce combiner >> Set.count)

let part1 = groupAnswers Set.union
let part2 = groupAnswers Set.intersect

let solution = part1, part2
