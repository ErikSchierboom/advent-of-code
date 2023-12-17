#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <numeric>
#include <array>
#include <functional>
#include <ranges>
#include <string_view>

using namespace std;

typedef unordered_map<string, array<string, 2>> Nodes;

int num_steps(string from, string directions, Nodes nodes, function<bool(string)> stop) {
//    for (auto s : views::repeat("I know that you know that"sv)
//                  | views::take(3))

    string current = from;
    auto steps = 0;

    while (true) {
        for (const auto direction : string_view(directions)) {
            if (stop(current)) return steps;
            current = nodes[current][direction == 'R'];
            ++steps;
        }
    }
}

unsigned long solve(string directions, Nodes nodes, function<bool(string)> start, function<bool(string)> stop) {
    auto start_nodes = nodes | views::filter([&](const auto &kv) { return start(kv.first); });
    return accumulate(start_nodes.begin(), start_nodes.end(), 1ul, [&](const auto steps, const auto kv) {
        return lcm(steps, num_steps(kv.first, directions, nodes,[&](string name) { return stop(name); }));
    });
}

unsigned long part_a(string directions, Nodes nodes) {
    return solve(directions, nodes, [](const auto& name) { return name == "AAA"; }, [](const auto& name) { return name == "ZZZ"; });
}

unsigned long part_b(string directions, Nodes nodes) {
    return solve(directions, nodes, [](const auto& name) { return name.ends_with('A'); }, [](const auto& name) { return name.ends_with('Z'); });
}

pair<string, Nodes> parse() {
    ifstream ifs("input.txt", ifstream::in);

    string directions; getline(ifs, directions);
    string line; getline(ifs, line);

    Nodes nodes{};
    while (getline(ifs, line))
        nodes.insert_or_assign(line.substr(0, 3), array<string,2> { line.substr(7, 3), line.substr(12, 3) });

    return {directions, nodes};
}

int main() {
    const auto& [directions, nodes] = parse();
    cout << "Part a: " << part_a(directions, nodes) << endl;
    cout << "Part a: " << part_b(directions, nodes) << endl;
    return 0;
}