module AdventOfCode.Day19

open FParsec

let p0, p0Ref = createParserForwardedToRef<unit, unit>()
let p1, p1Ref = createParserForwardedToRef<unit, unit>()
let p2, p2Ref = createParserForwardedToRef<unit, unit>()
let p3, p3Ref = createParserForwardedToRef<unit, unit>()
let p4, p4Ref = createParserForwardedToRef<unit, unit>()
let p5, p5Ref = createParserForwardedToRef<unit, unit>()

//0: 4 1 5
//1: 2 3 | 3 2
//2: 4 4 | 5 5
//3: 4 5 | 5 4
//4: "a"
//5: "b"
//
//ababbb
//bababa
//abbbab
//aaabbb
//aaaabbb

do p0Ref := p4 .>> p1 .>> p5 
do p1Ref := choice [attempt (p2 >>. p3); p3 >>. p2]
do p2Ref := choice [attempt (p4 >>. p4); p5 >>. p5]
do p3Ref := choice [attempt (p4 >>. p5); p5 >>. p4]
do p4Ref := pchar 'a' >>% ()
do p5Ref := pchar 'b' >>% ()

printfn "%A" (run (p0 .>> notFollowedBy anyChar) "ababbb")
printfn "%A" (run (p0 .>> notFollowedBy anyChar) "aaaabbb")

//printfn "%A" (run p1 "aaab")  
//printfn "%A" (run p1 "aaba")  
//printfn "%A" (run p1 "bbab")
//printfn "%A" (run p1 "bbba")
//printfn "%A" (run p1 "abaa")  
//printfn "%A" (run p1 "abbb")  
//printfn "%A" (run p1 "baaa")
//printfn "%A" (run p1 "babb")
//
//printfn "%A" (run p3 "ab")
//printfn "%A" (run p3 "ba")
//
//printfn "%A" (run p2 "aa")
//printfn "%A" (run p2 "bb")

// 1 = aaab | aaba | bbab | bbba | abaa | abbb | baaa | babb 
// 2 = aa | bb
// 3 = ab | ba
// 4 = a
// 5 = b 

let rules, messages =
    let lines = Input.asLines 19
    let rules = lines |> Seq.takeWhile (fun line -> line.Length <> 0)
    let messages = lines |> Seq.skipWhile (fun line -> line.Length <> 0) |> Seq.tail |> Seq.toArray    
    rules, messages

let part1 = 0
    
let part2 = 0

let solution = part1, part2
