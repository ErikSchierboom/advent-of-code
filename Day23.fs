module AdventOfCode.Day23

open System.Collections.Generic

let initialLabels = [ 5; 8; 3; 9; 7; 6; 2; 4; 1 ]

let createCups (labels: int seq) =
    let cups = Dictionary<int, int>()
    labels |> Seq.pairwise |> Seq.iter cups.Add

    cups.Add(Seq.last labels, Seq.head labels)
    cups

let applyMoves count current max (cups: Dictionary<int, int>) =
    let rec applyMove round current =
        if round > count then
            cups
        else
            let pickUpBegin = cups.[current]
            let pickUpMiddle = cups.[pickUpBegin]
            let pickUpEnd = cups.[pickUpMiddle]

            let destination =
                seq {
                    yield! seq { current - 1 .. -1 .. 1 }
                    yield! seq { max .. -1 .. current + 1 }
                } |> Seq.find (fun i -> i <> pickUpBegin && i <> pickUpMiddle && i <> pickUpEnd)

            let destinationNext = cups.[destination]
            cups.[current] <- cups.[pickUpEnd]
            cups.[pickUpEnd] <- destinationNext
            cups.[destination] <- pickUpBegin

            applyMove (round + 1) cups.[current]

    applyMove 1 current

let part1 =
    let finalCups = applyMoves 10 initialLabels.Head (List.max initialLabels) (createCups initialLabels)

    Seq.unfold (fun i -> if i = 1 then None else Some(i, finalCups.[i])) finalCups.[1]
    |> Seq.map string
    |> Seq.toArray
    |> String.concat ""

let part2 =    
    let cups = createCups initialLabels
    
    let numberOfCups = 1_000_000
    Seq.init (numberOfCups - initialLabels.Length) ((+) (initialLabels.Length + 1))
    |> Seq.iter (fun i -> cups.Add(i, i + 1))

    cups.[List.last initialLabels] <- initialLabels.Length + 1
    cups.[numberOfCups] <- List.head initialLabels

    let finalCups = applyMoves 10_000_000 initialLabels.Head numberOfCups cups
    int64 finalCups.[1] * int64 finalCups.[finalCups.[1]]

let solution = part1, part2
