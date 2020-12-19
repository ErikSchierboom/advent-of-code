module AdventOfCode.Day17

open System.Collections.Generic
open System.Diagnostics

type PocketDimension = HashSet<int * int * int * int>

let input = Input.asLines 17
let dimension = input.Length

let initialState =
    input
    |> Seq.indexed
    |> Seq.collect (fun (y, line) -> line |> Seq.indexed |> Seq.choose (fun (x, letter) -> if letter = '#' then Some (x, y, 0, 0) else None))
    |> PocketDimension

let neighbors3d (x, y, z, w) =
    seq {
        for dx in -1..1 do
        for dy in -1..1 do
        for dz in -1..1 do
           if dx <> 0 || dy <> 0 || dz <> 0 then
               yield (x + dx, y + dy, z + dz, 0)   
    }
    
let neighbors4d (x, y, z, w) =
    seq {
        for dx in -1..1 do
        for dy in -1..1 do
        for dz in -1..1 do
        for dw in -1..1 do
            if dx <> 0 || dy <> 0 || dz <> 0 || dw <> 0 then
                yield (x + dx, y + dy, z + dz, w + dw)
    } 

let isActive (state: PocketDimension) coord = state.Contains(coord)

let activeNeighbors dimensionNeighbors (state: PocketDimension) coord =
    dimensionNeighbors coord
    |> Seq.filter state.Contains
    |> Seq.length

let applyRulesToCoord dimensionNeighbors originalState (newState: PocketDimension) coord =
    match isActive originalState coord, activeNeighbors dimensionNeighbors originalState coord with
    | true,  2
    | true,  3
    | false, 3 ->
        newState.Add(coord) |> ignore
        newState
    | _, _ ->
        newState

let activeCubesAfterCycles dimensionNeighbors =
    let rec loop currentCycle (currentState: PocketDimension) =
        if currentCycle = 6 then
            currentState.Count
        else
            currentState
            |> Seq.collect dimensionNeighbors
            |> Seq.distinct
            |> Seq.fold (applyRulesToCoord dimensionNeighbors currentState) (PocketDimension())
            |> loop (currentCycle + 1)

    loop 0 initialState

let part1 = activeCubesAfterCycles neighbors3d
let part2 = activeCubesAfterCycles neighbors4d

let solution = part1, part2
