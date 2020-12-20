module AdventOfCode.Day18

open FParsec

let equations = Input.asLines 18

let pTerm = puint64 .>> spaces
let pChar c = pchar c .>> spaces
let opp = OperatorPrecedenceParser<_, _, _>()
let pExpression = opp.ExpressionParser
opp.TermParser <- pTerm <|> between (pChar '(') (pChar ')' .>> spaces) pExpression
opp.AddOperator(InfixOperator("*", spaces, 1, Associativity.Left, (*)))
opp.AddOperator(InfixOperator("+", spaces, 1, Associativity.Left, (+)))

let evaluate line =
    match run pExpression line with
    | Success (expression, _, _) -> expression
    | Failure _ -> failwith "Invalid expression"

let part1 = Seq.sumBy evaluate equations

let part2 = 0

let solution = part1, part2
