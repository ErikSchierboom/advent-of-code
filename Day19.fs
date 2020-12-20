﻿module AdventOfCode.Day19

open FParsec

let p0, p0Ref = createParserForwardedToRef<unit, unit>()
let p1, p1Ref = createParserForwardedToRef<unit, unit>()
let p2, p2Ref = createParserForwardedToRef<unit, unit>()
let p3, p3Ref = createParserForwardedToRef<unit, unit>()
let p4, p4Ref = createParserForwardedToRef<unit, unit>()
let p5, p5Ref = createParserForwardedToRef<unit, unit>()

do p0Ref := p4 .>> p1 .>> p5 
do p1Ref := choice [attempt (p2 >>. p3); p3 >>. p2]
do p2Ref := choice [attempt (p4 >>. p4); p5 >>. p5]
do p3Ref := choice [attempt (p4 >>. p5); p5 >>. p4]
do p4Ref := pchar 'a' >>% ()
do p5Ref := pchar 'b' >>% ()

let matches message =
    match run p0 message with
    | Success _ -> true
    | Failure _ -> false

type Rule =
    | Constant of int * char
    | Sequence of int * int list
    | OneOrOther of int * int list * int list

let pLetter = asciiLetter
let pNumber = pint32
let pNumbers = sepEndBy1 pint32 (pchar ' ')
let pSeparator = pchar ':' .>> spaces
let pConstant = pNumber .>> pSeparator .>>. (between (pchar '"') (pchar '"') pLetter) |>> Constant
let pSequence = pNumber .>> pSeparator .>>. pNumbers |>> Sequence
let pOneOrOther = pNumber .>> pSeparator .>>. pNumbers .>> spaces .>> pstring "|" .>> spaces .>>. pNumbers |>> fun ((number, left), right) -> OneOrOther (number, left, right)
let pRule = choice [attempt pConstant; attempt pOneOrOther; pSequence]

let pMessage = many1Chars pLetter


let runParser parser input =
    match run parser input with
    | Success (result, _, _) -> result
    | Failure (error, _, _) -> failwith error

//0: 4 1 5
//1: 2 3 | 3 2
//2: 4 4 | 5 5
//3: 4 5 | 5 4
//4: "a"
//

printfn "%A" (run pConstant "5: \"b\"")
printfn "%A" (run pSequence "0: 4 1 5")
printfn "%A" (run pOneOrOther "3: 4 5 | 5 4")
printfn "%A" (run pMessage "abasd")

//let rules, messages =
//    let lines = Input.asLines 19
//    let rules = lines |> Seq.takeWhile (fun line -> line.Length <> 0) |> Seq.map parseRule
//    let messages = lines |> Seq.skipWhile (fun line -> line.Length <> 0) |> Seq.tail |> Seq.toArray    
//    rules, messages

let part1 =
//    printfn "%A" (rules |> Seq.toArray)
    0
//    messages
//    |> Seq.filter matches
//    |> Seq.length
    
    
let part2 = 0

let solution = part1, part2
