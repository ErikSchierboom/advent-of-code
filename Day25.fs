module AdventOfCode.Day25

open System.Collections.Generic

let cardPublicKey, doorPublicKey = Input.asLines 25 |> fun lines -> uint64 lines.[0], uint64 lines.[1]
let transform subjectNumber =
    let cache = Dictionary<int, uint64>()
    cache.Add(0, 1UL)
    
    let rec valueForLoop loop =
        match cache.TryGetValue(loop) with
        | true, value ->
            value
        | false, _    -> 
            let value = valueForLoop (loop - 1) * subjectNumber % 20201227UL
            cache.Add(loop, value)
            value
    
    valueForLoop

let loopSize publicKey =
    let transform = transform 7UL
    Seq.initInfinite ((+) 1) |> Seq.find (fun i -> transform i = publicKey)

//printfn "%A" (loopSize 5764801UL)  
//printfn "%A" (loopSize 17807724UL)  
//printfn "%A" (transform 7UL 8)  
//printfn "%A" (transform 17807724UL 8)

//let part1 = 0
//let part1 = loopSize cardPublicKey
let part1 = transform doorPublicKey 7731677
//|> transform doorPublicKey

let part2 = 0

let solution = part1, part2
