module AdventOfCode.Day18

open FParsec

type Expression =
    | Operand of int
    | PlusOperation of Expression * Expression
    | MultiplyOperation of Expression * Expression

let input = Input.asLines 18

let pExpression, pExpressionRef = createParserForwardedToRef<Expression, unit>()

let opp = OperatorPrecedenceParser<_, _, _>()
let expr = opp.ExpressionParser
let pTerm = pint32 >>. spaces |>> Operand
opp.TermParser <- pTerm <|> between (pchar '(') (pchar ')') expr
opp.AddOperator(InfixOperator("+", spaces, 1, Associativity.None, fun x y -> PlusOperation(x, y)))
opp.AddOperator(InfixOperator("*", spaces, 1, Associativity.None, fun x y -> MultiplyOperation(x, y)))


//1 + (2 * 3) + (4 * (5 + 6))

let part1 =
//    printfn "%A" (run pExpression "1 + (2 * 3) + (4 * (5 + 6))" )
    printfn "%A" (run pExpression "1 + (2)" )
    
    0
let part2 = 0

let solution = part1, part2
