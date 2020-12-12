module AdventOfCode.Day12

let instructions = Input.asLines 12

let rotate (y, x) degrees =
    match degrees with
    | 90  -> -x,  y
    | 180 -> -y, -x
    | 270 ->  x, -y
    | _   ->  y,  x

let applyInstruction move (ship, waypoint) (instruction: string) =    
    let action = instruction.[0]
    let value = int instruction.[1..]
    
    match action with
    | 'N' -> move (ship, waypoint) ( value, 0)
    | 'S' -> move (ship, waypoint) (-value, 0)
    | 'E' -> move (ship, waypoint) (0 ,  value)
    | 'W' -> move (ship, waypoint) (0 , -value)
    | 'L' -> ship, rotate waypoint (360 - value)
    | 'R' -> ship, rotate waypoint value
    | 'F' -> (fst ship + fst waypoint * value, snd ship + snd waypoint * value), waypoint
    | _   -> failwith "Unknown action"

let manhattanDistance move waypoint =
    let manhattanDistanceForShip ((shipY, shipX), _) = abs shipX + abs shipY
    
    instructions
    |> Array.fold (applyInstruction move) ((0, 0), waypoint)
    |> manhattanDistanceForShip

let part1 =
    let move ((shipY, shipX), waypoint) (dy, dx) = (shipY + dy, shipX + dx), waypoint
    manhattanDistance move (0, 1)

let part2 =
    let move (ship, (waypointY, waypointX)) (dy, dx) = ship, (waypointY + dy, waypointX + dx)        
    manhattanDistance move (1, 10)

let solution = part1, part2