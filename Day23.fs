module AdventOfCode.Day23

//let initialCups = [3; 8; 9; 1; 2; 5; 4; 6; 7]
let initialCups = [5; 8; 3; 9; 7; 6; 2; 4; 1]

let applyMoves count cups =
    let rec applyMove round cups =
        if round = count then
            cups
        else        
            match cups with
            | current::remainder ->
                let pickUp = remainder.[0..2]
                                
                let destination =
                    remainder.[3..]
                    |> List.sortDescending
                    |> List.partition ((>) current)
                    |> fun (smaller, larger) -> smaller @ larger
                    |> List.head
                
                let destinationIndex = List.findIndex ((=) destination) remainder
                let beforeDestination = remainder.[3..destinationIndex]
                let afterDestination = remainder.[destinationIndex + 1..]
                
                let reordered = beforeDestination @ pickUp @ afterDestination @ [current]

//                printfn "move: %A" round        
//                printfn "cups: (%A) %s" current (remainder |> Seq.map string |> String.concat " ")
//                printfn "pick up: %s" (pickUp |> Seq.map string |> String.concat " ")
//                printfn "destination: %A" destination
                
                applyMove (round + 1) reordered
            | _ -> failwith "Should not occur"
    
    let finalOrdering = applyMove 0 cups
    let oneIndex = finalOrdering |> List.findIndex ((=) 1)
    finalOrdering.[oneIndex + 1..] @ finalOrdering.[0..oneIndex - 1] |> Seq.map string |> Seq.toArray |> String.concat ""

let part1 =
    printfn "%A" <| applyMoves 100 initialCups
    
    0

let part2 = 0

let solution = part1, part2
