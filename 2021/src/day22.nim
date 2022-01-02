import helpers, std/[sets, sequtils, strscans, strutils]

type 
  Cube = tuple[x, y, z: int]
  Cuboid = tuple[on: bool, min, max: Cube]

proc readCuboids: seq[Cuboid] =
  for (_, on, xMin, xMax, yMin, yMax, zMin, zMax) in readInputScans(day = 22, pattern = "$w x=$i..$i,y=$i..$i,z=$i..$i"):
    result.add (on: on == "on", min: (x: xMin, y: yMin, z: zMin), max: (x: xMax, y: yMax, z: zMax))

iterator cubes(cuboid: Cuboid): Cube =
  for x in cuboid.min.x..cuboid.max.x:
    for y in cuboid.min.y..cuboid.max.y:
      for z in cuboid.min.z..cuboid.max.z:
        yield (x: x, y: y, z: z)

proc solveDay22*: IntSolution =
  let cuboids = readCuboids()

  var cubes = initHashSet[Cube]()

  for cuboid in readCuboids():
    for x in cuboid.min.x..cuboid.max.x:
      for y in cuboid.min.y..cuboid.max.y:
        for z in cuboid.min.z..cuboid.max.z:
          echo ""
          # if cuboid.on: cubes.incl cube else: cubes.excl cube

  # result.part1 = initCubes.len
  # result.part2 = cubes.len

when isMainModule:
  echo solveDay22()
