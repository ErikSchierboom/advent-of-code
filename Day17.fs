module AdventOfCode.Day17

// TODO: use array; calculate from dimensions * number of round

let initialState =
    Input.asLines 17
    |> Seq.indexed
    |> Seq.collect (fun (y, line) -> line |> Seq.indexed |> Seq.map (fun (x, letter) -> (x, y, 0, 0), letter = '#' ))
    |> Map.ofSeq

let neighbors3d (x, y, z, w) =
    [for dx in -1..1 do
     for dy in -1..1 do
     for dz in -1..1 do
        if dx <> 0 || dy <> 0 || dz <> 0 then
            yield x + dx, y + dy, z + dz, 0]
    
let neighbors4d (x, y, z, w) =
    [for dx in -1..1 do
     for dy in -1..1 do
     for dz in -1..1 do
     for dw in -1..1 do
        if dx <> 0 || dy <> 0 || dz <> 0 || dw <> 0 then
            yield x + dx, y + dy, z + dz, w + dw]

let isActive state coord = Map.tryFind coord state |> Option.map ((=) true) |> Option.defaultValue false

let activeNeighbors dimensionNeighbors state coord =
    dimensionNeighbors coord
    |> Seq.filter (isActive state)
    |> Seq.length

let applyRulesToCoord dimensionNeighbors originalState newState coord =
    match isActive originalState coord, activeNeighbors dimensionNeighbors originalState coord with
    | true,  2
    | true,  3
    | false, 3 -> Map.add coord true newState
    | _, _     -> Map.add coord false newState


let applyRules dimensionNeighbors state =
    state
    |> Map.toSeq
    |> Seq.map fst
    |> Seq.collect dimensionNeighbors
    |> set
    |> Seq.fold (applyRulesToCoord dimensionNeighbors state) state

let part1 =
    let x =
        initialState
        |> applyRules neighbors3d
        |> applyRules neighbors3d
        |> applyRules neighbors3d
        |> applyRules neighbors3d
        |> applyRules neighbors3d
        |> applyRules neighbors3d
        
    let y =
        x
        |> Map.toSeq
        |> Seq.map snd
        |> Seq.filter ((=) true)
        |> Seq.length
    
    y
    
let part2 = 0

let solution = part1, part2
