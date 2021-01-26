module AdventOfCode.Day16

open System
open System.Text.RegularExpressions

let scannedTickets = Input.asString 16
let scannedTicketsSegments = scannedTickets.Split("\r\n\r\n")

let parseTicket ticket = Regex.Matches(ticket, "(\d+)") |> Seq.map (fun m -> int m.Value) |> Seq.toArray
let myTicket = scannedTicketsSegments.[1].Trim() |> parseTicket
let nearbyTickets =
    scannedTicketsSegments.[2].Trim().Split("\n", StringSplitOptions.RemoveEmptyEntries)
    |> Array.tail
    |> Array.map parseTicket

let fieldRules =
    Regex.Matches(scannedTicketsSegments.[0].Trim(), "([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)")
    |> Seq.map (fun m -> m.Groups.[1].Value, ((int m.Groups.[2].Value, int m.Groups.[3].Value), (int m.Groups.[4].Value, int m.Groups.[5].Value)))
    |> Seq.toArray
let rules = fieldRules |> Seq.map snd

let validForRule value ((min1, to1), (from2, to2)) = value >= min1 && value <= to1 || value >= from2 && value <= to2    
let invalidForAllRules value = rules |> Seq.forall (validForRule value >> not)

let part1 =
    nearbyTickets
    |> Seq.concat
    |> Seq.filter invalidForAllRules
    |> Seq.sum

let part2 =
    nearbyTickets
    |> Array.filter (fun values -> values |> Seq.exists invalidForAllRules |> not)
    |> Array.transpose
    |> Array.indexed
    |> Array.map (fun (i, column) -> i, fieldRules |> Seq.filter (fun (_, rule) -> column |> Seq.forall (fun value -> validForRule value rule)) |> Seq.map fst |> Set.ofSeq)
    |> Array.sortBy (fun (_, rules) -> rules.Count)
    |> Array.fold (fun (mapping, processed) (col, candidates) ->
        let field = Set.difference candidates processed |> Seq.head
        Map.add field col mapping, Set.add field processed
    ) (Map.empty, Set.empty)
    |> fst
    |> Map.toSeq
    |> Seq.filter (fun (field, _) -> field.StartsWith("departure"))
    |> Seq.map (fun (_, col) -> uint64 myTicket.[col])
    |> Seq.reduce (*)

let solution = part1, part2
