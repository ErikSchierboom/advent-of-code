import helpers, std/[options, strscans]

type 
  Point3D = tuple[x, y, z: int]
  Cuboid = tuple[on: bool, min, max: Point3D]

func volume(cuboid: Cuboid): int {.inline.} =
  let total = (cuboid.max.x - cuboid.min.x + 1) * (cuboid.max.y - cuboid.min.y + 1) * (cuboid.max.z - cuboid.min.z + 1)
  if cuboid.on: total else: -total

func `*`(left, right: Cuboid): Option[Cuboid] {.inline.} =
  let min = (x: max(left.min.x, right.min.x), y: max(left.min.y, right.min.y), z: max(left.min.z, right.min.z))
  let max = (x: min(left.max.x, right.max.x), y: min(left.max.y, right.max.y), z: min(left.max.z, right.max.z))
  if max.x >= min.x and max.y >= min.y and max.z >= min.z:
    result = some (on: not left.on, min: min, max: max)

func inInitRegion(cuboid: Cuboid): bool {.inline.} =
  cuboid.min.x in -50..50 and cuboid.max.x in -50..50 and
  cuboid.min.y in -50..50 and cuboid.max.y in -50..50 and 
  cuboid.min.z in -50..50 and cuboid.max.z in -50..50

proc readCuboids: seq[Cuboid] =
  for (_, on, xMin, xMax, yMin, yMax, zMin, zMax) in readInputScans(day = 22, pattern = "$w x=$i..$i,y=$i..$i,z=$i..$i"):
    result.add (on: on == "on", min: (x: xMin, y: yMin, z: zMin), max: (x: xMax, y: yMax, z: zMax))

proc solveDay22*: IntSolution =
  let cuboids = readCuboids()
  var processedCuboids: seq[Cuboid]

  for cuboid in cuboids:
    var addToProcessed: seq[Cuboid]

    for processed in processedCuboids:
      let intersection = processed * cuboid
      if intersection.isSome:
        addToProcessed.add intersection.get

    processedCuboids.add addToProcessed
    if cuboid.on:
      processedCuboids.add cuboid

  for cuboid in processedCuboids:
    if cuboid.inInitRegion:
      inc result.part1, cuboid.volume

    inc result.part2, cuboid.volume

when isMainModule:
  echo solveDay22()
