module AdventOfCode.Day21

let parseFood (line: string) =
    let line = line.Replace("(", "").Replace(")", "").Replace(",", "")
    let words (str: string) = str.Split(" ") |> set
       
    match line.Split(" contains ") |> Array.toList with
    | [ingredientsStr] -> words ingredientsStr, Set.empty  
    | [ingredientsStr; allergensStr] -> words ingredientsStr, words allergensStr
    | _ -> failwith "Invalid line"

let foods = Input.asLines 21 |> Array.map parseFood
    
let allergies =
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
    
let part1 =
    
    
    let allergenIngredients =    
        allergies
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
    
let part2 =
    let rec loop mapping remainder =
        match remainder with
        | [] ->
            mapping
        | (ingredient, allergens)::xs ->
            let allergen = Seq.head allergens
            let updated =
                xs
                |> List.map (fun (ingredient, allergens) -> ingredient, Set.remove allergen allergens)
                |> List.sortBy (fun (ingredient, allergens) -> Set.count allergens)
            loop (Map.add ingredient allergen mapping) updated
        
    loop Map.empty (allergies |> Map.toList |> List.sortBy (fun (ingredient, allergens) -> Set.count allergens))
    |> Map.toSeq
    |> Seq.sortBy fst
    |> Seq.map snd
    |> String.concat ","

let solution = part1, part2
