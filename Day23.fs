module AdventOfCode.Day23

open System.Collections.Generic

let initialLabels = [3; 8; 9; 1; 2; 5; 4; 6; 7]
//let initialCups = [5; 8; 3; 9; 7; 6; 2; 4; 1]

let createCups (labels: int list) =
    let cups = Dictionary<int, int>()

    labels
    |> Seq.pairwise
    |> Seq.iter cups.Add
    
    cups.Add(List.last labels, List.head labels)
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
    
//    printfn "%s" (cups |> Seq.map (fun kv -> sprintf "%d => %d" kv.Key kv.Value) |> String.concat ", ")

let applyMoves count (labels: int list) =
    let rec applyMove round (current: int) (cups: Dictionary<int, int>) =
        if round > count then
            cups
        else
            printfn "move: %d" round        
            printfn "cups: %s" (print current cups)

            let next = cups.[current]
            let nextNext = cups.[next] 
            let nextNextNext = cups.[nextNext]
            
            let destination =
                [current - 1 .. -1 .. 1]
                |> List.tryFind (fun i ->
                    i <> next &&
                    i <> nextNext &&
                    i <> nextNextNext)
                |> Option.defaultValue (List.max labels)
            
            printfn "pick up: %d %d %d" next nextNext nextNextNext
            printfn "destination: %A" destination
            printfn ""
            
            // TODO: swapparoo
            
            applyMove (round + 1) (cups.[current]) cups
    
    let cups = createCups labels
    let current = List.head labels

    applyMove 1 current cups

let part1 =
    let ordering = applyMoves 10 initialLabels
    0
//    let one = ordering.Find(1)
//    
//    let before =
//        Seq.unfold (fun (elem: LinkedListNode<int>) -> if elem = null then None else Some(elem.Value, elem.Previous)) one.Previous
//        |> Seq.rev
//        |> Seq.toList
//    
//    let after =
//        Seq.unfold (fun (elem: LinkedListNode<int>) -> if elem = null then None else Some(elem.Value, elem.Next)) one.Next
//        |> Seq.toList
//
//    after @ before |> Seq.map string |> Seq.toArray |> String.concat ""

let part2 =
//    let ordering = applyMoves 10_000_000 (initialCups @ List.init (10_000_000 - initialCups.Length) (fun i -> i + initialCups.Length))
//    let one = ordering.Find(1)
//    let firstAfterOne = if one.Next = null then ordering.First else one.Next
//    let secondAfterOne = if one.Next = null || one.Next.Next = null then ordering.First.Next else one.Next.Next
//    firstAfterOne.Value * secondAfterOne.Value
    0

let solution = part1, part2
