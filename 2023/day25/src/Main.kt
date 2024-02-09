typealias Graph = MutableMap<String, MutableList<String>>

fun main() {
    println("part a: ${part1()}")
}

private fun part1(): Int {
    fun String.numNodes() = count { it == '-' } + 1

    while (true) {
        val (a, b) = contract(parseGraph()).toList()
        if (a.second.size == 3) return a.first.numNodes() * b.first.numNodes()
    }
}

private fun parseGraph(): Graph {
    return {}::class.java.getResource("input.txt").readText().replace(":", "").lines()
        .map { it.split(' ') }
        .flatMap { it.drop(1).flatMap { component -> listOf(it[0] to component, component to it[0]) } }
        .groupByTo(mutableMapOf(), { it.first }, { it.second })
}

private fun contract(graph: Graph): Graph {
    // Use Karger's algorithm to determine minimum cut: https://en.wikipedia.org/wiki/Karger%27s_algorithm
    if (graph.size == 2) return graph

    val a = graph.keys.random()
    val b = graph[a]!!.random()
    val newNode = "$a-$b"

    graph[newNode] = (graph[a]!! + graph[b]!! - setOf(a, b)).toMutableList()
    (graph.remove(a)!! + graph.remove(b)!!).forEach { c ->
        graph[c]?.also {
            it.add(newNode)
            it.remove(a)
            it.remove(b)
        }
    }

    return contract(graph)
}
