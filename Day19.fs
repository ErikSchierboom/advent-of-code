module AdventOfCode.Day19

open FParsec

//let p0, p0Ref = createParserForwardedToRef<unit, unit>()
//let p1, p1Ref = createParserForwardedToRef<unit, unit>()
//let p2, p2Ref = createParserForwardedToRef<unit, unit>()
//let p3, p3Ref = createParserForwardedToRef<unit, unit>()
//let p4, p4Ref = createParserForwardedToRef<unit, unit>()
//let p5, p5Ref = createParserForwardedToRef<unit, unit>()
//
//do p0Ref := p4 .>> p1 .>> p5 
//do p1Ref := choice [attempt (p2 >>. p3); attempt (p3 >>. p2)]
//do p2Ref := choice [attempt (p4 >>. p4); attempt (p5 >>. p5)]
//do p3Ref := choice [attempt (p4 >>. p5); attempt (p5 >>. p4)]
//do p4Ref := pchar 'a' >>% ()
//do p5Ref := pchar 'b' >>% ()
//
//let matches message =
//    match run (p0 .>> notFollowedBy anyChar) message with
//    | Success _ -> true
//    | Failure _ -> false
//    
//printfn "%A" (matches "ababbb")
//printfn "%A" (matches "bababa")
//printfn "%A" (matches "abbbab")
//printfn "%A" (matches "aaabbb")
//printfn "%A" (matches "aaaabbb")

type Rule =
    | Constant of int * char
    | Sequence of int * int list
    | OneOrOther of int * int list * int list

let ruleNumber = function
    | Constant (number, _)
    | Sequence (number, _)
    | OneOrOther (number, _, _) -> number

let pLetter = asciiLetter
let pNumber = pint32
let pNumbers = sepEndBy1 pint32 (pchar ' ')
let pSeparator = pchar ':' .>> spaces
let pConstant = pNumber .>> pSeparator .>>. (between (pchar '"') (pchar '"') pLetter) |>> Constant
let pSequence = pNumber .>> pSeparator .>>. pNumbers |>> Sequence
let pOneOrOther = pNumber .>> pSeparator .>>. pNumbers .>> spaces .>> pstring "|" .>> spaces .>>. pNumbers |>> fun ((number, left), right) -> OneOrOther (number, left, right)
let pRule = choice [attempt pConstant; attempt pOneOrOther; pSequence]
let pMessage = many1Chars pLetter
let pInput = sepEndBy1 pRule newline .>> skipNewline .>>. sepEndBy1 pMessage newline

let runParser parser input =
    match run parser input with
    | Success (result, _, _) -> result
    | Failure (error, _, _) -> failwith error

let rules, messages = runParser pInput (Input.asString 19)

//let p0, p0Ref = createParserForwardedToRef<unit, unit>()
//let p1, p1Ref = createParserForwardedToRef<unit, unit>()
//let p2, p2Ref = createParserForwardedToRef<unit, unit>()
//let p3, p3Ref = createParserForwardedToRef<unit, unit>()
//let p4, p4Ref = createParserForwardedToRef<unit, unit>()
//let p5, p5Ref = createParserForwardedToRef<unit, unit>()
//
//do p0Ref := p4 .>> p1 .>> p5 
//do p1Ref := choice [attempt (p2 >>. p3); attempt (p3 >>. p2)]
//do p2Ref := choice [attempt (p4 >>. p4); attempt (p5 >>. p5)]
//do p3Ref := choice [attempt (p4 >>. p5); attempt (p5 >>. p4)]
//do p4Ref := pchar 'a' >>% ()
//do p5Ref := pchar 'b' >>% ()
//
//let matches message =
//    match run (p0 .>> notFollowedBy anyChar) message with
//    | Success _ -> true
//    | Failure _ -> false
//    
//printfn "%A" (matches "ababbb")
//printfn "%A" (matches "bababa")
//printfn "%A" (matches "abbbab")
//printfn "%A" (matches "aaabbb")
//printfn "%A" (matches "aaaabbb")

let parserForRules =
    let parsers = rules |> List.fold (fun acc rule -> Map.add (ruleNumber rule) (createParserForwardedToRef<unit, unit>()) acc) Map.empty
    let updateParser i p = do Map.find i parsers |> snd := p
    let pLetter letter = pchar letter >>% ()
    let pSequence sequence = sequence |> Seq.map (fun i -> Map.find i parsers |> fst) |> Seq.reduce ((.>>))
     
    rules
    |> List.map (fun rule ->
        match rule with
        | Constant (i, letter) -> i, pLetter letter
        | Sequence (i, sequence) -> i, pSequence sequence
        | OneOrOther (i, left, right) -> i, choice [pSequence left |> attempt; pSequence right |> attempt]
    )
    |> List.iter (fun (i, p) -> updateParser i p)

    parsers

let part1 =
    let pRuleZero = parserForRules |> Map.find 0 |> fst .>> notFollowedBy anyChar  
    
    let matchesRuleZero message =
        match run pRuleZero message with
        | Success _ -> true
        | Failure _ -> false
    
    messages
    |> Seq.filter matchesRuleZero
    |> Seq.length
    
let part2 = 0

let solution = part1, part2


//0: 4 1 5
//1: 2 3 | 3 2
//2: 4 4 | 5 5
//3: 4 5 | 5 4
//4: "a"
//

//let input =
//    "0: 4 1 5\n" +
//    "1: 2 3 | 3 2\n" +
//    "2: 4 4 | 5 5\n" +
//    "3: 4 5 | 5 4\n" +
//    "4: \"a\"\n" +
//    "5: \"b\"\n" +
//    "\n" +
//    "ababbb\n" +
//    "bababa\n" +
//    "abbbab\n" +
//    "aaabbb\n" +
//    "aaaabbb"
//
//printfn "%A" (run pConstant "5: \"b\"")
//printfn "%A" (run pSequence "0: 4 1 5")
//printfn "%A" (run pOneOrOther "3: 4 5 | 5 4")
//printfn "%A" (run pMessage "abasd")
//printfn "%A" (run pInput input)