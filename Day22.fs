module AdventOfCode.Day22

let lines = Input.asLines 22

let parseHand lines = lines |> Seq.map int |> Seq.toList

let player1Hand =
    lines
    |> Seq.tail
    |> Seq.takeWhile (System.String.IsNullOrEmpty >> not)
    |> parseHand

let player2Hand =
    lines
    |> Seq.skipWhile (System.String.IsNullOrEmpty >> not)
    |> Seq.skip 2
    |> parseHand

printfn "%A" player1Hand
printfn "%A" player2Hand

let part1 = 0
    
    
let part2 = 0

let solution = part1, part2
