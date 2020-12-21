module AdventOfCode.Day20

module Array2D =    
    let rotate arr = Array2D.init (Array2D.length2 arr) (Array2D.length1 arr) (fun row col -> Array2D.get arr (Array2D.length1 arr - col - 1) row)

let linedUp (tiles: (int * char [,]) []) =
    let dimension = tiles.Length |> float |> sqrt |> int

    let rows = tiles |> Array.map snd |> Array.chunkBySize dimension
    let cols = rows |> Array.transpose 

    let linedUpVertically =
        rows
        |> Array.pairwise
        |> Array.forall (fun (top, bottom) ->
            let x = top |> Array.collect (fun l -> l.[^0, *]) |> Seq.toArray |> System.String
            let y = bottom |> Array.collect (fun l -> l.[0, *]) |> Seq.toArray |> System.String
            x = y
        )
        
    let linedUpHorizontally =
        cols
        |> Array.pairwise
        |> Array.forall (fun (left, right) ->
            let x = left |> Array.collect (fun l -> l.[*, ^0]) |> Seq.toArray |> System.String
            let y = right |> Array.collect (fun l -> l.[*, 0]) |> Seq.toArray |> System.String
            x = y
        )
    
    linedUpVertically && linedUpHorizontally

let tiles =
    Input.asLines 20
    |> Array.chunkBySize 12
    |> Array.map (fun lines -> int lines.[0].[5..8], Array2D.init 10 10 (fun row col -> lines.[row + 1].[col]))

printfn "%A" (linedUp tiles)

let part1 =
    
    
//    printfn "%A" tiles.[*, 0]
    0

let part2 = 0

let solution = part1, part2

//let x1 = array2D [ [0; 1; 2]; [3; 4; 5]; [6; 7; 8] ]
//let x2 = array2D [ [6; 7; 8]; [3; 4; 5]; [0; 1; 2] ]
//let x3 = array2D [ [2; 6; 7]; [5; 5; 5]; [8; 4; 4] ]
//
//printfn "%A" (x1 |> Array2D.rotate)
//
//
//printfn "%A" (x1.[0..^0, *] |> Array2D.rows)
//printfn "%A" (x1.[0..^0, *] |> Array2D.cols)
//
//printfn "%A" (horizontallyLinedUp x1 x3)
//printfn "%A" (horizontallyLinedUp x1 x2)
//
//printfn "%A" (verticallyLinedUp x1 x3)
//printfn "%A" (verticallyLinedUp x1 x2)