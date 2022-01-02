import helpers, std/[sets, strscans, strutils]

type 
  Point3D = tuple[x, y, z: int]
  Cuboid = tuple[on: bool, x, y, z: tuple[min, max: int]]

iterator readCuboids: Cuboid =
  for (_, on, xMin, xMax, yMin, yMax, zMin, zMax) in readInputScans(day = 22, pattern = "$w x=$i..$i,y=$i..$i,z=$i..$i"):
    yield (on: on == "on", x: (min: xMin, max: xMax), y: (min: yMin, max: yMax), z: (min: zMin, max: zMax))

proc solveDay22*: IntSolution =
  var cubes: HashSet[Point3D]

  for cuboid in readCuboids():
    if cuboid.x.min >= -50 and cuboid.x.max <= 50 and
       cuboid.y.min >= -50 and cuboid.y.max <= 50 and
       cuboid.z.min >= -50 and cuboid.z.max <= 50:
      for x in cuboid.x.min..cuboid.x.max:
        for y in cuboid.y.min..cuboid.y.max:
          for z in cuboid.z.min..cuboid.z.max:
              let cube = (x: x, y: y, z: z)
              if cuboid.on:
                cubes.incl cube
              else:
                cubes.excl cube

  result.part1 = cubes.len

when isMainModule:
  echo solveDay22()
