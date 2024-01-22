open System.IO
open System.Collections.Generic

type Slopes = Regular | Slippery
type Coord = int * int
type Grid = { start: Coord; stop: Coord; masks: Map<Coord, uint64>; neighbors: Map<Coord, (Coord * int) list> }

let parseCells lines =
    lines
    |> Seq.mapi(fun y line -> line |> Seq.mapi(fun x c -> ((x, y), c)))
    |> Seq.concat
    |> Seq.filter(fun (_, c) -> c <> '#')
    |> Map.ofSeq

let findNeighbors cells (x, y) =
    [(-1, 0); (1, 0); (0, 1); (0, -1)]
    |> Seq.map (fun (dx, dy) -> (x + dx, y + dy))
    |> Seq.filter (fun coord -> Map.containsKey coord cells)
    |> Set.ofSeq
    
let walk slopes cells neighbors from =
    let rec inner current visited =
        let neighbors = Set.difference (Map.find current neighbors) visited
        match neighbors.Count with
        | 1 -> inner (Seq.head neighbors) (Set.add current visited)
        | _ -> from, current, visited.Count
    
    Map.find from neighbors
    |> Seq.choose (fun neighbor ->
        let neighborCell = Map.find neighbor cells
        if slopes = Regular ||
           fst neighbor = fst from - 1 && neighborCell <> '>' ||
           fst neighbor = fst from + 1 && neighborCell <> '<' ||
           snd neighbor = snd from - 1 && neighborCell <> 'v' ||
           snd neighbor = snd from + 1 && neighborCell <> '^' then
            Some (inner neighbor (Set.singleton from))
        else
            None
    )
    |> Seq.toList

let findEdges useSlopes cells start stop  =
    let neighbors = cells |> Map.map (fun coord _ -> findNeighbors cells coord)

    neighbors
    |> Map.toList
    |> List.filter (fun (_, nodeNeighbors) -> Set.count nodeNeighbors > 2)
    |> List.map fst
    |> List.append [start; stop]
    |> List.collect (walk useSlopes cells neighbors)

let parseGrid useSlopes =
    let lines = File.ReadAllLines("input.txt")
    let cells = parseCells lines
    let start = cells |> Map.findKey (fun (_, y) _ -> y = 0)
    let stop = cells |> Map.findKey (fun (_, y) _ -> y = lines.Length - 1)
    let edges = findEdges useSlopes cells start stop    
    let neighbors =
        edges
        |> Seq.groupBy (fun (a, _, _) -> a)
        |> Seq.map (fun (k, v) -> k, v |> Seq.map (fun (_, b, c) -> b,c) |> Seq.toList)
        |> Map.ofSeq        
    let masks = neighbors |> Map.keys |> Seq.distinct |> Seq.sort |> Seq.indexed |> Seq.map (fun (i, coord) -> coord, 1UL <<< i) |> Map.ofSeq
    
    { start = start; stop = stop; masks = masks; neighbors = neighbors }

let longestHikeSteps useSlopes =
    let grid = parseGrid useSlopes
    let maxSteps = Dictionary<Coord, int>()
    
    let rec inner current currentSteps visited =
        if current = grid.stop then
            if currentSteps > maxSteps.GetValueOrDefault(current, -1) then
                maxSteps[current] <- currentSteps
        else
            for neighbor, neighborSteps in grid.neighbors[current] do
                if visited &&& grid.masks[neighbor] = 0UL then
                    inner neighbor (currentSteps + neighborSteps)  (visited ||| grid.masks[neighbor])

    inner grid.start 0 grid.masks[grid.start]
    maxSteps[grid.stop]

printfn $"part a: {longestHikeSteps Slippery}"
printfn $"part b: {longestHikeSteps Regular}"
