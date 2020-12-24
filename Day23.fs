module AdventOfCode.Day23

open System.Collections.Generic

let initialCups = [3; 8; 9; 1; 2; 5; 4; 6; 7]
//let initialCups = [5; 8; 3; 9; 7; 6; 2; 4; 1]

// Intrinsic and optional extensions
type LinkedListNode<'T> with
    member self.NextSafe = if self.Next = null then self.List.First else self.Next

let applyMoves count (cups: int list) =    
    let initialOrdering = LinkedList(cups)

    let cupToNodes = Seq.unfold (fun (elem: LinkedListNode<int>) -> if elem = null then None else Some((elem.Value, elem), elem.Next)) initialOrdering.First |> Map.ofSeq
    let max = List.max cups
    let maxCup = cupToNodes |> Map.find max
    let pickUp = List<LinkedListNode<int>>(3)

    let rec applyMove round (current: LinkedListNode<int>) (ordering: LinkedList<int>) =
        if round > count then
            ordering
        else
//            printfn "move: %d" round        
//            printfn "cups: %s" (ordering |> Seq.cast<int> |> Seq.map (fun elem ->
//                if elem = current.Value then sprintf "(%d)" elem else sprintf "%d" elem
//                )
//                |> String.concat " ")

            pickUp.Clear()
            
            [0..2]
            |> List.iter (fun _ ->
                let node = if current.Next = null then ordering.First else current.Next
                pickUp.Add(node)
                ordering.Remove(node)                
            )
            
            let destination =
                [current.Value - 1 .. -1 .. 1]
                |> List.tryFind (fun i ->
                    i <> pickUp.[0].Value &&
                    i <> pickUp.[1].Value &&
                    i <> pickUp.[2].Value)
                |> Option.map (fun i -> Map.find i cupToNodes)
                |> Option.defaultValue maxCup

//            printfn "pick up: %s" (pickUp |> Seq.cast<int> |> Seq.map string |> String.concat " ")
//            printfn "destination: %A" destination.Value
//            printfn ""
            
            pickUp
            |> Seq.rev
            |> Seq.iter (fun node ->
//                let elem = Map.find value cupToNodes
                ordering.AddAfter(destination, node)
            )

            let next = if current.Next = null then ordering.First else current.Next
            applyMove (round + 1) next ordering
    
    applyMove 1 initialOrdering.First initialOrdering

let part1 =
    let ordering = applyMoves 100 initialCups
    let one = ordering.Find(1)
    
    let before =
        Seq.unfold (fun (elem: LinkedListNode<int>) -> if elem = null then None else Some(elem.Value, elem.Previous)) one.Previous
        |> Seq.rev
        |> Seq.toList
    
    let after =
        Seq.unfold (fun (elem: LinkedListNode<int>) -> if elem = null then None else Some(elem.Value, elem.Next)) one.Next
        |> Seq.toList

    after @ before |> Seq.map string |> Seq.toArray |> String.concat ""

let part2 =
//    let ordering = applyMoves 10_000_000 (initialCups @ List.init (10_000_000 - initialCups.Length) (fun i -> i + initialCups.Length))
//    let one = ordering.Find(1)
//    let firstAfterOne = if one.Next = null then ordering.First else one.Next
//    let secondAfterOne = if one.Next = null || one.Next.Next = null then ordering.First.Next else one.Next.Next
//    firstAfterOne.Value * secondAfterOne.Value
    0

let solution = part1, part2
