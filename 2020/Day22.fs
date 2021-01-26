module AdventOfCode.Day22

open System

type Winner = Player1 | Player2

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

let playCombatRecursive hand1 hand2  =
    let rec play previousRounds hand1 hand2 =        
        match hand1, hand2 with
        | _, _ when Set.contains (hand1, hand2) previousRounds -> (Player1, hand1, hand2)
        | card1::cards1, card2::cards2 when cards1.Length >= card1 && cards2.Length >= card2 ->
            match play Set.empty (cards1.[0..card1 - 1]) (cards2.[0..card2 - 1]) with
            | Player1, _, _ -> play (Set.add (hand1, hand2) previousRounds) (cards1 @ [card1; card2]) cards2
            | Player2, _, _ -> play (Set.add (hand1, hand2) previousRounds) cards1 (cards2 @ [card2; card1])
        | card1::cards1, card2::cards2 when card1 > card2 -> play (Set.add (hand1, hand2) previousRounds) (cards1 @ [card1; card2]) cards2
        | card1::cards1, card2::cards2 when card2 > card1 -> play (Set.add (hand1, hand2) previousRounds) cards1 (cards2 @ [card2; card1])
        | [], _  -> (Player2, hand1, hand2)
        | _ , [] -> (Player1, hand1, hand2)
        | _, _ -> failwith "Should not happen"
        
    match play Set.empty hand1 hand2 with
    | Player1, hand1, _ -> score hand1
    | Player2, _, hand2 -> score hand2

let part1 = playCombat initialHand1 initialHand2

let part2 = playCombatRecursive initialHand1 initialHand2

let solution = part1, part2
