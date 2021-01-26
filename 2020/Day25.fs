module AdventOfCode.Day25

let cardPublicKey, doorPublicKey = Input.asLines 25 |> fun lines -> uint64 lines.[0], uint64 lines.[1]

let transform subjectNumber value = value * subjectNumber % 20201227UL

let loopSize publicKey =    
    let rec inner value loop =
        let transformed = transform 7UL value         
        if transformed = publicKey then loop else inner transformed (loop + 1)

    inner 1UL 1

let encryptionKey subjectNumber value loopSize =
    let rec inner acc loop = if loop = loopSize then acc else inner (transform subjectNumber acc) (loop + 1)        
    inner value 0

let part1 = loopSize cardPublicKey |> encryptionKey doorPublicKey 1UL
let part2 = 0

let solution = part1, part2
