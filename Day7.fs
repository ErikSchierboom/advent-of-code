module AdventOfCode.Day7

open System.Text.RegularExpressions

let bags =
    Input.asLines 7
    |> Seq.fold (fun acc elem ->
        let matched = Regex.Match(elem, "^(?<outer>\w+ \w+) bags contain (no other bags|(?<count>\d+) (?<inner>\w+ \w+) (bags?, |bag.))+")
        let outerColor = matched.Groups.["outer"].Value
        let innerColors = matched.Groups.["inner"].Captures |> Seq.map (fun capture -> capture.Value)
        let innerColorCounts = matched.Groups.["count"].Captures |> Seq.map (fun capture -> capture.Value |> int)
        let innerColorToCount = innerColorCounts |> Seq.zip innerColors |> Map.ofSeq
        Map.add outerColor innerColorToCount acc
    ) Map.empty

let myBagColor = "shiny gold"

let part1 =
    let rec canContainMyBag _ innerColors =
        innerColors |> Map.containsKey myBagColor ||
        innerColors |> Map.exists (fun innerColor _ -> Map.find innerColor bags |> canContainMyBag innerColor)

    bags
    |> Map.fold (fun count outerColor innerColors -> if canContainMyBag outerColor innerColors then count + 1 else count) 0

let part2 =
    let rec bagCount outerColor =
        Map.find outerColor bags
        |> Map.fold (fun count innerColor innerCount -> count + innerCount + innerCount * bagCount innerColor) 0

    bagCount myBagColor

let solution = part1, part2