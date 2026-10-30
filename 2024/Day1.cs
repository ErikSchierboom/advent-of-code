var input = File.ReadAllText("Day1.txt");

var firstIds = new List<int>();
var secondIds = new List<int>();
var secondIdCounts = new Dictionary<int, int>();

foreach (var line in input.EnumerateLines())
{
    var parts = line.Split("   ");
    parts.MoveNext();
    var firstId = int.Parse(line[parts.Current]);
    parts.MoveNext();
    var secondId = int.Parse(line[parts.Current]);

    firstIds.Add(firstId);
    secondIds.Add(secondId);
    secondIdCounts[secondId] = secondIdCounts.GetValueOrDefault(secondId) + 1;
}

firstIds.Sort();
secondIds.Sort();

var part1 = firstIds.Zip(secondIds, (a, b) => Math.Abs(a - b)).Sum();
var part2 = firstIds.Sum(firstId => firstId * secondIdCounts.GetValueOrDefault(firstId, 0));

Console.WriteLine($"Part 1: {part1}");
Console.WriteLine($"Part 2: {part2}");
