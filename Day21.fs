module AdventOfCode.Day21

let parseFood (line: string) =
    let line = line.Replace("(", "").Replace(")", "").Replace(",", "")
    let words (str: string) = str.Split(" ") |> set
       
    match line.Split(" contains ") |> Array.toList with
    | [ingredientsStr] -> words ingredientsStr, Set.empty  
    | [ingredientsStr; allergensStr] -> words ingredientsStr, words allergensStr
    | _ -> failwith "Invalid line"

let foods = Input.asLines 21 |> Array.map parseFood
    
let part1 =
    let allergenIngredients = 
    
        foods
        |> Seq.fold (fun acc (ingredients, allergens) ->
            allergens
            |> Seq.fold (fun acc allergen ->
                match Map.tryFind allergen acc with
                | Some history -> Map.add allergen (ingredients :: history) acc
                | None -> Map.add allergen [ingredients] acc
            ) acc
        ) Map.empty
        |> Map.map (fun _ ingredients -> ingredients |> List.reduce Set.intersect)
        |> Map.toSeq
        |> Seq.map snd
        |> Seq.reduce Set.union

    let nonAllergenIngredients =
        foods
        |> Seq.collect fst
        |> Seq.except allergenIngredients
    
    foods
    |> Seq.collect fst
    |> Seq.filter (fun ingredient -> Seq.contains ingredient nonAllergenIngredients)
    |> Seq.length
    
let part2 = 0

let solution = part1, part2
