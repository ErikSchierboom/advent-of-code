﻿module AdventOfCode.Day23

open System.Collections.Generic

let initialCups = [3; 8; 9; 1; 2; 5; 4; 6; 7]
//let initialCups = [5; 8; 3; 9; 7; 6; 2; 4; 1]

let applyMoves count (cups: int list) =
    let cupsInOrder = LinkedList()
    
    let cupsByValue =
        cups
        |> Seq.map (fun cup -> cup, cupsInOrder.AddLast(cup))
        |> Map.ofSeq
    
    let rec applyMove round (current: LinkedListNode<int>) (ordering: LinkedList<int>) =
        if round = count then
            ordering
        else
            let pickUp = [current.Next; current.Next.Next; current.Next.Next.Next]
            
            printfn "move: %d" round        
            printfn "cups: (%d) %s" current.Value (ordering |> Seq.cast<int> |> Seq.tail |> Seq.map string |> String.concat " ")
            printfn "pick up: %s" (pickUp |> Seq.map (fun elem -> elem.Value |> string) |> String.concat " ")
            
            let destination =
                ordering
                |> Seq.cast<int>
                |> Seq.sortDescending
                |> Seq.tryFind (fun i -> i < current.Value && pickUp |> List.forall (fun elem -> elem.Value <> i))

            printfn "destination: %A" destination
            
//            match cups with
//            | current::remainder ->
//                let pickUp = remainder.[0..2]
//                                
//                let destination =
//                    remainder.[3..]
//                    |> List.sortDescending
//                    |> List.partition ((>) current)
//                    |> fun (smaller, larger) -> smaller @ larger
//                    |> List.head
//                
//                let destinationIndex = List.findIndex ((=) destination) remainder
//                let beforeDestination = remainder.[3..destinationIndex]
//                let afterDestination = remainder.[destinationIndex + 1..]
//                
//                let reordered = beforeDestination @ pickUp @ afterDestination @ [current]

            // TODO
            applyMove (round + 1) current ordering
    
    let finalOrdering = applyMove 0 cupsInOrder.First cupsInOrder
    printfn "%A" finalOrdering
    
    finalOrdering
//    let finalOrdering = applyMove 0 cups
//    let oneIndex = finalOrdering |> List.findIndex ((=) 1)
//    finalOrdering.[oneIndex + 1..] @ finalOrdering.[0..oneIndex - 1]

let part1 =
    applyMoves 10 initialCups    
//    applyMoves 100 initialCups    
    |> Seq.map string |> Seq.toArray |> String.concat ""

let part2 =
    0
//    applyMoves 10_000_000 (initialCups @ List.init (10_000_000 - initialCups.Length) (fun i -> i + initialCups.Length)) 
//    |> List.take 2
//    |> List.reduce (*)

let solution = part1, part2
