fun getResourceAsText(path: String) = object {}.javaClass.getResource(path).readText()

fun getResourceAsLines(path: String) = getResourceAsText(path).lines()

fun getResourceAsInts(path: String) = getResourceAsLines(path).map(String::toInt)
