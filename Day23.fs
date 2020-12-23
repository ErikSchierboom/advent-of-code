module AdventOfCode.Day23

open System.Collections.Generic

let initialCups = [3; 8; 9; 1; 2; 5; 4; 6; 7]
//let initialCups = [5; 8; 3; 9; 7; 6; 2; 4; 1]

let applyMoves count (cups: int list) =
    let initialOrdering = LinkedList(cups)
    let orderedDescending = cups |> List.sortDescending |> List.map initialOrdering.Find
    let pickUp = LinkedList<int>()
        
    let rec applyMove round (current: LinkedListNode<int>) (ordering: LinkedList<int>) =
        if round > count then
            ordering
        else
//            printfn "move: %d" round        
//            printfn "cups: %s" (ordering |> Seq.cast<int> |> Seq.map (fun elem ->
//                if elem = current.Value then sprintf "(%d)" elem else sprintf "%d" elem
//                )
//                |> String.concat " ")
            
            [0..2]
            |> List.iter (fun _ ->
                let node = if current.Next = null then ordering.First else current.Next
                ordering.Remove(node)
                pickUp.AddLast(node)
            )
            
            let nonPickUp = orderedDescending |> List.filter (fun elem -> not (pickUp.Contains(elem.Value)))
            
            let destination =
                nonPickUp
                |> List.tryFind (fun elem -> elem.Value < current.Value)
                |> Option.defaultValue nonPickUp.[0]

//            printfn "pick up: %s" (pickUp |> Seq.cast<int> |> Seq.map string |> String.concat " ")
//            printfn "destination: %A" destination.Value
//            printfn ""
            
            pickUp
            |> Seq.cast
            |> Seq.rev
            |> Seq.iter (fun value ->
                let elem = pickUp.Find(value)
                pickUp.Remove(elem)
                ordering.AddAfter(destination, elem)
            )
            
            let next = if current.Next = null then ordering.First else current.Next
            applyMove (round + 1) next ordering
    
    applyMove 1 initialOrdering.First initialOrdering

let part1 =
    let ordering = applyMoves 10 initialCups
    let one = ordering.Find(1)
    
    let before: int list =
        Seq.unfold (fun (elem: LinkedListNode<int>) ->
            if elem = null then None
            else Some(elem.Value, elem.Previous)
        ) one.Previous
        |> Seq.rev
        |> Seq.toList
    
    let after: int list =
        Seq.unfold (fun (elem: LinkedListNode<int>) ->
            if elem = null then None
            else Some(elem.Value, elem.Next)
        ) one.Next
        |> Seq.toList

    after @ before    
    |> Seq.map string |> Seq.toArray |> String.concat ""

let part2 =
    let ordering = applyMoves 10_000_000 (initialCups @ List.init (10_000_000 - initialCups.Length) (fun i -> i + initialCups.Length))
    let one = ordering.Find(1)
    let firstAfterOne = if one.Next = null then ordering.First else one.Next
    let secondAfterOne = if one.Next = null || one.Next.Next = null then ordering.First.Next else one.Next.Next
    firstAfterOne.Value * secondAfterOne.Value

let solution = part1, part2
