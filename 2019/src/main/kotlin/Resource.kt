fun readResourceAsText(path: String) = object {}.javaClass.getResource(path).readText()

fun readResourceAsLines(path: String) = readResourceAsText(path).lines()

fun readResourcesAsInts(path: String) = readResourceAsLines(path).map(String::toInt)
