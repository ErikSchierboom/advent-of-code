module AdventOfCode.Day17

// TODO: use array; calculate from dimensions * number of round

let input = Input.asLines 17
let dimension = input.Length

let initialState =
    input
    |> Seq.indexed
    |> Seq.collect (fun (y, line) -> line |> Seq.indexed |> Seq.choose (fun (x, letter) -> if letter = '#' then Some (x, y, 0, 0) else None))
    |> Set.ofSeq

let neighbors3d (x, y, z, w) =
    seq {
        for dx in -1..1 do
        for dy in -1..1 do
        for dz in -1..1 do
           if dx <> 0 || dy <> 0 || dz <> 0 then
               yield x + dx, y + dy, z + dz, 0   
    } |> Set.ofSeq
    
let neighbors4d (x, y, z, w) =
    seq {
        for dx in -1..1 do
        for dy in -1..1 do
        for dz in -1..1 do
        for dw in -1..1 do
            if dx <> 0 || dy <> 0 || dz <> 0 || dw <> 0 then
                yield x + dx, y + dy, z + dz, w + dw
    } |> Set.ofSeq

let isActive state coord = Set.contains coord state

let activeNeighbors dimensionNeighbors state coord = Set.intersect state (dimensionNeighbors coord) |> Set.count

let applyRulesToCoord dimensionNeighbors originalState newState coord =
    match isActive originalState coord, activeNeighbors dimensionNeighbors originalState coord with
    | true,  2
    | true,  3
    | false, 3 -> Set.add coord newState
    | _, _     -> newState

let activeCubesAfterCycles dimensionNeighbors =
    let rec loop currentCycle currentState =
        if currentCycle = 6 then
            Set.count currentState
        else
            currentState
            |> Seq.collect dimensionNeighbors
            |> Set.ofSeq
            |> Seq.fold (applyRulesToCoord dimensionNeighbors currentState) Set.empty
            |> loop (currentCycle + 1)

    loop 0 initialState

let part1 = activeCubesAfterCycles neighbors3d

let part2 = activeCubesAfterCycles neighbors4d

let solution = part1, part2
