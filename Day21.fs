module AdventOfCode.Day21

open System.Text.RegularExpressions

let parseFood history (line: string) =
    let line = line.Replace("(", "").Replace(")", "").Replace(",", "")
    
    let ingredients, allergens =        
        match line.Split(" contains ") |> Array.toList with
        | [ingredientsStr] -> ingredientsStr.Split(" "), Array.empty  
        | [ingredientsStr; allergensStr] -> ingredientsStr.Split(" "), allergensStr.Split(" ")
        | _ -> failwith "Invalid line"

    allergens
    |> Seq.fold (fun acc allergen ->
        match Map.tryFind allergen acc with
        | Some history -> Map.add allergen (ingredients :: history) acc
        | None -> Map.add allergen [ingredients] acc
    ) history

let part1 =
    Input.asLines 21
    |> Array.fold parseFood Map.empty
    |> printfn "%A"
    
let part2 = 0

let solution = part1, part2
