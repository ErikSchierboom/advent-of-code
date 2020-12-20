module AdventOfCode.Day18

open FParsec

let equations = Input.asLines 18

let expressionParser (additionPrecedence, multiplyPrecedence) =
    let pTerm = puint64 .>> spaces
    let pChar c = pchar c .>> spaces
    let opp = OperatorPrecedenceParser<_, _, _>()
    let pExpression = opp.ExpressionParser
    opp.TermParser <- pTerm <|> between (pChar '(') (pChar ')' .>> spaces) pExpression
    opp.AddOperator(InfixOperator("+", spaces, additionPrecedence, Associativity.Left, (+)))
    opp.AddOperator(InfixOperator("*", spaces, multiplyPrecedence, Associativity.Left, (*)))        
    pExpression

let evaluateEquation precedence =
    let pExpression = expressionParser precedence 
    
    fun line ->
        match run pExpression line with
        | Success (expression, _, _) -> expression
        | Failure _ -> failwith "Invalid expression"
        
let sumEquations precedence = Seq.sumBy (evaluateEquation precedence) equations 

let part1 = sumEquations (1, 1)
let part2 = sumEquations (2, 1)

let solution = part1, part2
