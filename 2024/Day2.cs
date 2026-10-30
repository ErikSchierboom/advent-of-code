var input = """
            7 6 4 2 1
            1 2 7 8 9
            9 7 6 2 1
            1 3 2 4 5
            8 6 4 4 1
            1 3 6 7 9
            """;

foreach (var line in input.EnumerateLines())
{
    var numbers = line.Split(' ');
    numbers.MoveNext();
    var i = int.Parse(line[numbers.Current]);
}

// Console.WriteLine($"Part 1: {part1}");
// Console.WriteLine($"Part 2: {part2}");
