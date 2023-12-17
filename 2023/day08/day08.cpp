#include <iostream>
#include <fstream>
#include <string>
#include <unordered_map>
#include <numeric>
#include <array>
#include <functional>
#include <ranges>

typedef std::unordered_map<std::string, std::array<std::string, 2>> Nodes;

int num_steps(std::string from, std::string directions, Nodes nodes, std::function<bool(std::string)> stop) {
    std::string current = from;
    auto steps = 0;

    for (const auto iteration : std::views::repeat(directions)) {
        for (const auto direction : iteration) {
            if (stop(current)) return steps;
             current = nodes[current][direction == 'R'];
             ++steps;
        }
    }
}

unsigned long solve(std::string directions, Nodes nodes, std::function<bool(std::string)> start, std::function<bool(std::string)> stop) {
    auto start_nodes = nodes | std::ranges::views::filter([&](const auto &kv) { return start(kv.first); });
    return std::accumulate(start_nodes.begin(), start_nodes.end(), 1ul, [&](const auto steps, const auto kv) {
        return std::lcm(steps, num_steps(kv.first, directions, nodes,[&](std::string name) { return stop(name); }));
    });
}

unsigned long part_a(std::string directions, Nodes nodes) {
    return solve(directions, nodes, [](const auto& name) { return name == "AAA"; }, [](const auto& name) { return name == "ZZZ"; });
}

unsigned long part_b(std::string directions, Nodes nodes) {
    return solve(directions, nodes, [](const auto& name) { return name.ends_with('A'); }, [](const auto& name) { return name.ends_with('Z'); });
}

std::pair<std::string, Nodes> parse() {
    std::ifstream ifs("input.txt", std::ifstream::in);

    std::string directions; std::getline(ifs, directions);
    std::string line; std::getline(ifs, line);

    Nodes nodes{};
    while (std::getline(ifs, line))
        nodes.insert_or_assign(line.substr(0, 3), std::array<std::string,2> { line.substr(7, 3), line.substr(12, 3) });

    return {directions, nodes};
}

int main() {
    const auto& [directions, nodes] = parse();
    std::cout << "Part a: " << part_a(directions, nodes) << std::endl;
    std::cout << "Part a: " << part_b(directions, nodes) << std::endl;
    return 0;
}