defmodule Day19 do
  def solve() do
    {combinations, ratings} = parse()

    IO.puts("part a: #{part_a(combinations, ratings)}")
    IO.puts("part b: #{part_b(combinations)}")
  end

  def part_a(combinations, ratings) do
    ratings
    |> Enum.filter(&accepted_rating?(&1, combinations))
    |> Enum.flat_map(&Map.values/1)
    |> Enum.sum()
  end

  def part_b(combinations), do: Enum.map(combinations, &num_combinations/1) |> Enum.sum()

  def accepted_rating?(rating, combinations) do
    Enum.any?(combinations, fn combination ->
      Enum.all?(~w(s m a x)a, &(rating[&1] in combination[&1]))
    end)
  end

  def num_combinations(combination),
    do: Map.values(combination) |> Enum.map(&Enum.count/1) |> Enum.product()

  def intersect_range(r1, r2), do: max(r1.first, r2.first)..min(r1.last, r2.last)
  def invert_range(1..n), do: (n + 1)..4000
  def invert_range(n..4000), do: 1..(n - 1)

  def accepted_combinations(workflows), do: accepted_paths([], workflows[:in], workflows)

  def accepted_paths(_, [{:reject}], _), do: []
  def accepted_paths(path, [{:accept}], _), do: [path_to_combination(path)]

  def accepted_paths(path, [{:move_to, workflow}], workflows),
    do: accepted_paths(path, workflows[workflow], workflows)

  def accepted_paths(path, [{:accept, rating, range} | tail], workflows),
    do:
      accepted_paths([{:accept, rating, range} | path], [{:accept}], workflows) ++
        accepted_paths([{:accept, rating, invert_range(range)} | path], tail, workflows)

  def accepted_paths(path, [{:reject, rating, range} | tail], workflows),
    do: accepted_paths([{:accept, rating, invert_range(range)} | path], tail, workflows)

  def accepted_paths(path, [{:move_to, workflow, rating, range} | tail], workflows),
    do:
      accepted_paths([{:accept, rating, range} | path], workflows[workflow], workflows) ++
        accepted_paths([{:accept, rating, invert_range(range)} | path], tail, workflows)

  def path_to_combination(path) do
    Enum.reduce(path, %{x: 1..4000, m: 1..4000, a: 1..4000, s: 1..4000}, fn condition, ranges ->
      {rating, range} =
        case condition do
          {:accept, rating, range} -> {rating, range}
          {:reject, rating, range} -> {rating, invert_range(range)}
        end

      Map.update(ranges, rating, range, fn existing -> intersect_range(existing, range) end)
    end)
  end

  def parse() do
    File.read!("input.txt")
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
    |> then(fn [workflows_part, lines_part] ->
      {Enum.map(workflows_part, &parse_workflow/1) |> Enum.into(%{}) |> accepted_combinations(),
       Enum.map(lines_part, &parse_part/1)}
    end)
  end

  def parse_workflow(line) do
    [name, rules] = line |> String.trim_trailing("}") |> String.split("{")

    parsed_rules =
      rules
      |> String.split(",")
      |> Enum.map(&parse_rule/1)

    {String.to_atom(name), parsed_rules}
  end

  def parse_rule(["A"]), do: {:accept}
  def parse_rule(["R"]), do: {:reject}
  def parse_rule([workflow_name]), do: {:move_to, String.to_atom(workflow_name)}

  def parse_rule([
        %{"operand" => operand, "operator" => operator, "part_name" => part_name},
        workflow_name
      ]) do
    range =
      case operator do
        ">" -> (String.to_integer(operand) + 1)..4000
        "<" -> 1..(String.to_integer(operand) - 1)
      end

    case workflow_name do
      "A" -> {:accept, String.to_atom(part_name), range}
      "R" -> {:reject, String.to_atom(part_name), range}
      _ -> {:move_to, String.to_atom(workflow_name), String.to_atom(part_name), range}
    end
  end

  def parse_rule([condition, workflow_name]) do
    parse_rule([
      Regex.named_captures(
        ~r/(?<part_name>\w+)(?<operator>[<>])(?<operand>\d+)/,
        condition
      ),
      workflow_name
    ])
  end

  def parse_rule(rule), do: parse_rule(String.split(rule, ":"))

  def parse_part(line) do
    line
    |> String.trim_trailing("}")
    |> String.trim_leading("{")
    |> String.split(",")
    |> Enum.map(fn pair ->
      [key, value] = String.split(pair, "=")
      {String.to_atom(key), String.to_integer(value)}
    end)
    |> Enum.into(%{})
  end
end

Day19.solve()
