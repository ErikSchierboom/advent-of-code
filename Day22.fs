module AdventOfCode.Day22

open System

let lines = Input.asLines 22
let parseHand lines = lines |> Seq.map int |> Seq.toList
let initialHand1 = lines |> Seq.tail |> Seq.takeWhile (String.IsNullOrEmpty >> not) |> parseHand
let initialHand2 = lines |> Seq.skipWhile (String.IsNullOrEmpty >> not) |> Seq.skip 2 |> parseHand

let score hand =
    hand
    |> Seq.rev
    |> Seq.indexed
    |> Seq.sumBy (fun (i, card) -> (i + 1) * card)

let rec playCombat hand1 hand2 =
    match hand1, hand2 with
    | [], _  -> score hand2
    | _ , [] -> score hand1
    | card1::cards1, card2::cards2 when card1 > card2 -> playCombat (cards1 @ [card1; card2]) cards2
    | card1::cards1, card2::cards2 -> playCombat cards1 (cards2 @ [card2; card1])

let part1 = playCombat initialHand1 initialHand2

let part2 = 0

let solution = part1, part2
