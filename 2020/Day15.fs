module AdventOfCode.Day15

let numberSpoken atTurn =
    let history = Array.zeroCreate atTurn
    let startingNumbers = [1; 0; 18; 10; 19; 6]

    startingNumbers
    |> Seq.indexed
    |> Seq.iter (fun (i, number) -> history.[number] <- i + 1)

    let rec loop turn last current =
        if turn > atTurn then
            last
        else
            let next = if history.[current] = 0 then 0 else turn - history.[current]
            history.[current] <- turn            
            loop (turn + 1) current next
         
    loop (List.length startingNumbers + 1) (List.last startingNumbers) 0 

let part1 = numberSpoken 2020
let part2 = numberSpoken 30000000

let solution = part1, part2
