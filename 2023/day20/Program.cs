using System.Numerics;

Console.WriteLine($"part a: {PartA()}");
Console.WriteLine($"part b: {PartB()}");

int PartA()
{
    var lowPulsesSent = 0;
    var highPulsesSent = 0;

    return Solve<int>((signal, buttonPresses) =>
    {
        if (buttonPresses == 1000) return lowPulsesSent * highPulsesSent;
        
        if (signal.Pulse == Pulse.High)
            ++highPulsesSent;
        else
            ++lowPulsesSent;

        return null;
    });
}

BigInteger PartB()
{
    var lvCycles = new Dictionary<string, BigInteger>();

    return Solve<BigInteger>((signal, buttonPresses) =>
    {
        if (signal is not { Pulse: Pulse.High, Recipient: "lv" }) return null;
        if (lvCycles.ContainsKey(signal.Sender)) return null;

        lvCycles[signal.Sender] = new BigInteger(buttonPresses + 1);
        if (lvCycles.Count != 4) return null;

        return lvCycles.Values.Aggregate(LeastCommonMultiple);
    });

    BigInteger LeastCommonMultiple(BigInteger a, BigInteger b) => a / BigInteger.GreatestCommonDivisor(a, b) * b;
}

T Solve<T>(Func<Signal, int, T?> process) where T : struct
{
    var modules = Parse();

    for (var buttonPresses = 0; ; buttonPresses++)
    {
        var signals = new Queue<Signal>();
        signals.Enqueue(new("button", "broadcaster", Pulse.Low));
    
        while (signals.Count > 0)
        {
            var signal = signals.Dequeue();

            var result = process(signal, buttonPresses); 
            if (result != null) return result.Value;

            if (modules.TryGetValue(signal.Recipient, out var module))
                module.Process(signal, signals);
        }
    }
}

Dictionary<string, Module> Parse()
{
    var dictionary = File.ReadLines("input.txt").Select(ParseModule).ToDictionary(m => m.Name);

    foreach (var module in dictionary.Values)
        foreach (var destinationName in module.Destinations)
            if (dictionary.TryGetValue(destinationName, out var destination) && destination is ConjuctionModule conjuctionModule)
                conjuctionModule.AddInput(module.Name);
    
    return dictionary;

    Module ParseModule(string line) => line.Split(" -> ") switch
        {
            ["broadcaster", var destinations] => new BroadcastModule("broadcaster", destinations.Split(", ")),
            [var name, var destinations] when name.StartsWith('%') => new FlipFlopModule(name[1..], destinations.Split(", ")),
            [var name, var destinations] when name.StartsWith('&') => new ConjuctionModule(name[1..], destinations.Split(", ")),
        };
}

internal enum Pulse
{
    Low,
    High
}

internal sealed record Signal(string Sender, string Recipient, Pulse Pulse);

internal abstract class Module(string name, string[] destinations)
{
    public string Name { get; } = name;
    public string[] Destinations { get; } = destinations;

    public abstract void Process(Signal signal, Queue<Signal> signals);
}

internal sealed class FlipFlopModule(string name, string[] destinations) : Module(name, destinations)
{
    public Pulse Pulse;

    public override void Process(Signal signal, Queue<Signal> signals)
    {
        if (signal.Pulse == Pulse.High) return;

        Pulse = Pulse == Pulse.High ? Pulse.Low : Pulse.High;

        foreach (var destination in Destinations)
            signals.Enqueue(new(name, destination, Pulse));
    }
}

internal sealed class ConjuctionModule(string name, string[] destinations) : Module(name, destinations)
{
    public readonly Dictionary<string, Pulse> MostRecent = new();

    public void AddInput(string input) => MostRecent[input] = Pulse.Low;

    public override void Process(Signal signal, Queue<Signal> signals)
    {
        MostRecent[signal.Sender] = signal.Pulse;
        
        var pulse = MostRecent.Values.All(pulse => pulse == Pulse.High) ? Pulse.Low : Pulse.High;
        
        foreach (var destination in Destinations)
            signals.Enqueue(new(name, destination, pulse));
    }
}

internal sealed class BroadcastModule(string name, string[] destinations) : Module(name, destinations)
{
    public override void Process(Signal signal, Queue<Signal> signals)
    {
        foreach (var destination in Destinations)
            signals.Enqueue(new(name, destination, signal.Pulse));
    }
}
