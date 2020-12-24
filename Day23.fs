module AdventOfCode.Day23

open System.Collections.Generic

let initialLabels = [3; 8; 9; 1; 2; 5; 4; 6; 7]
//let initialCups = [5; 8; 3; 9; 7; 6; 2; 4; 1]

let createCups (labels: int seq) =
    let cups = Dictionary<int, int>()

    labels
    |> Seq.pairwise
    |> Seq.iter cups.Add
    
    cups.Add(Seq.last labels, Seq.head labels)
    cups

let print current (cups: Dictionary<int, int>) =
    let rec iter (acc: string list) key =
        if key = current then
            iter ((sprintf "(%d)" key)::acc) (cups.[key])
        else            
            let next = cups.[key]
            if next = current then
                (sprintf "%d" key)::acc
            else
                iter (sprintf "%d" key::acc) next
        
    iter [] current |> List.rev |> String.concat " "

let applyMoves count current max (cups: Dictionary<int, int>) =
    let rec applyMove round current =
        if round > count then
            cups
        else
            let next = cups.[current]
            let nextNext = cups.[next] 
            let nextNextNext = cups.[nextNext]
            
            let destination =
                seq { current - 1 .. -1 .. 1 }
                |> Seq.tryFind (fun i -> i <> next && i <> nextNext && i <> nextNextNext)
                |> Option.defaultValue (seq { max .. -1 .. current } |> Seq.find (fun i -> i <> next && i <> nextNext && i <> nextNextNext))
            
//            printfn "move: %d" round        
//            printfn "cups: %s" (print current cups)
//            printfn "pick up: %d %d %d" next nextNext nextNextNext
//            printfn "destination: %A" destination
//            printfn ""
            
            let pickUpNext = cups.[nextNextNext]
            let destinationNext = cups.[destination]
            cups.[current] <- pickUpNext
            cups.[destination] <- next
            cups.[nextNextNext] <- destinationNext
            
            applyMove (round + 1) (cups.[current])
    
    applyMove 1 current

let part1 =
    let cups = createCups initialLabels
    let current = initialLabels.Head
    let max = List.max initialLabels
    let finalCups = applyMoves 10 current max cups
    
    Seq.unfold (fun i -> if i = 1 then None else Some(i, finalCups.[i])) finalCups.[1]
    |> Seq.map string
    |> Seq.toArray
    |> String.concat ""

let part2 =
//    let extendedLabels = initialLabels @ List.init (10_000_000 - initialLabels.Length) (fun i -> i + initialLabels.Length + 1)
    let cups = createCups initialLabels
//    let finalCups = applyMoves 10 initialLabels.Head cups
    
//    let ordering = applyMoves 10_000_000 ()
//    let one = ordering.Find(1)
//    let firstAfterOne = if one.Next = null then ordering.First else one.Next
//    let secondAfterOne = if one.Next = null || one.Next.Next = null then ordering.First.Next else one.Next.Next
//    firstAfterOne.Value * secondAfterOne.Value
    0

let solution = part1, part2
