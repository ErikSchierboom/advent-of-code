module AdventOfCode.Day21

let parseFood (line: string) =
    let line = line.Replace("(", "").Replace(")", "").Replace(",", "")
    let words (str: string) = str.Split(" ") |> set
       
    match line.Split(" contains ") with
    | [| ingredientsStr |] -> words ingredientsStr, Set.empty  
    | [| ingredientsStr; allergensStr |] -> words ingredientsStr, words allergensStr
    | _ -> failwith "Invalid line"

let foods = Input.asLines 21 |> Array.map parseFood

let ingredientsToAllergens =
    let allergies =
        foods
        |> Seq.collect (fun (ingredients, allergens) -> allergens |> Seq.map (fun allergen -> allergen, ingredients))
        |> Seq.groupBy fst
        |> Seq.map (fun (allergen, group) -> allergen, group |> Seq.map snd |> Seq.reduce Set.intersect)
        |> Map.ofSeq
    
    let rec loop mapping remainder =
        match remainder |> List.sortBy (snd >> Set.count) with
        | [] ->
            mapping
        | (ingredient, allergens)::xs ->
            let allergen = Seq.head allergens
            let updated =
                xs
                |> List.map (fun (ingredient, allergens) -> ingredient, Set.remove allergen allergens)
                
            loop (Map.add ingredient allergen mapping) updated
        
    loop Map.empty (allergies |> Map.toList)
    |> Map.toSeq

let part1 =
    let ingredientsWithoutAllergens =
        foods
        |> Seq.collect fst
        |> Seq.except (ingredientsToAllergens |> Seq.map snd
        )
        |> Set.ofSeq
    
    foods
    |> Seq.collect fst
    |> Seq.filter (fun ingredient -> Set.contains ingredient ingredientsWithoutAllergens)
    |> Seq.length
    
let part2 =
    ingredientsToAllergens
    |> Seq.sortBy fst
    |> Seq.map snd
    |> Seq.toArray
    |> String.concat ","

let solution = part1, part2
