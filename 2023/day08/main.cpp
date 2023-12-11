#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <numeric>
#include <vector>

class Node {
public:
    std::string name;
    std::shared_ptr<Node> left;
    std::shared_ptr<Node> right;

    Node(std::string n) : name(n), left(nullptr), right(nullptr) {}

    std::shared_ptr<Node> move(char direction) {
        return direction == 'L' ? left : right;
    }

    std::shared_ptr<Node> move(std::string directions) {
        auto current = this;
        for (const auto& direction : directions)
            current = current->move(direction).get();

        return std::make_shared<Node>(*current);
    }
};

std::pair<std::string, std::unordered_map<std::string, std::shared_ptr<Node>>> parse() {
    std::ifstream ifs("input.txt", std::ifstream::in);

    std::string directions;
    std::getline(ifs, directions);

    std::string line;
    std::getline(ifs, line);

    std::unordered_map<std::string, std::shared_ptr<Node>> nodes{};

    auto create_or_add_node = [&] (std::string node_name) {
        return nodes.try_emplace(node_name, std::make_shared<Node>(node_name)).first->second;
    };

    while (std::getline(ifs, line))
    {
        auto node = create_or_add_node(line.substr(0, 3));
        node->left = create_or_add_node(line.substr(7, 3));
        node->right = create_or_add_node(line.substr(12, 3));
    }

    return std::pair(directions, nodes);
}

void part_a(std::string directions, std::unordered_map<std::string, std::shared_ptr<Node>> nodes) {
    auto steps = 0;
    auto current = nodes["AAA"];

    while (current->name != "ZZZ") {
        current = current->move(directions[steps % directions.length()]);
        ++steps;
    }

    std::cout << "Part a: " << steps << std::endl;
}

void part_b(std::string directions, std::unordered_map<std::string, std::shared_ptr<Node>> nodes) {
    std::unordered_map<std::string, std::string> end_nodes{};
    std::vector<std::shared_ptr<Node>> start_nodes{};

    for (const auto& [node_name, node] : nodes) {
        end_nodes[node_name] = node->move(directions)->name;
        if (node_name.ends_with('A')) start_nodes.push_back(node);
    }

    auto steps = 1ul;
    for (const auto node : start_nodes) {
        int node_steps = 0;

        auto current = node;
        while (!current->name.ends_with('Z')) {
            current = nodes[end_nodes[current->name]];
            node_steps += directions.size();
        }

        steps = std::lcm(steps, node_steps);
    }

    std::cout << "Part b: " << steps << std::endl;
}

int main() {
    auto [directions, nodes] = parse();
    part_a(directions, nodes);
    part_b(directions, nodes);
    return 0;
}
