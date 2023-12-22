const std = @import("std");
const allocator = std.heap.page_allocator;

const Direction = enum {
    north,
    east,
    south,
    west,
};

const Point = struct {
    x: u32,
    y: u32,

    pub fn add(self: Point, direction: Direction) Point {
        return switch (direction) {
            .north => .{ .x = self.x, .y = self.y + 1 },
            .south => .{ .x = self.x, .y = self.y - 1 },
            .east => .{ .x = self.x + 1, .y = self.y },
            .west => .{ .x = self.x - 1, .y = self.y },
        };
    }
};

fn area(polygon: []Point) u64 {
    // Use Shoalace Theorem
    var result: i64 = 0;
    for (0..polygon.len) |i| {
        var j = @rem(i + 1, polygon.len);
        result += @intCast(polygon[i].x * polygon[j].y);
        result -= @intCast(polygon[j].x * polygon[i].y);
    }
    return @as(u64, @intCast(@divTrunc(result, 2)));
}

fn numInnerPoints(polygon: []Point, numPoints: usize) u64 {
    // Use Pick's Theorem
    return area(polygon) - @divTrunc(numPoints, 2) + 1;
}

fn pipeDirectionsMap() !std.AutoHashMap(u8, [2]Direction) {
    var pipes = std.AutoHashMap(u8, [2]Direction).init(allocator);
    try pipes.put('|', [_]Direction{ .north, .south });
    try pipes.put('-', [_]Direction{ .west, .east });
    try pipes.put('L', [_]Direction{ .south, .east });
    try pipes.put('J', [_]Direction{ .south, .west });
    try pipes.put('7', [_]Direction{ .west, .north });
    try pipes.put('F', [_]Direction{ .east, .north });
    return pipes;
}

fn parse() !struct { start: Point, pipes: *std.AutoHashMap(Point, u8) } {
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var bufReader = std.io.bufferedReader(file.reader());
    var inStream = bufReader.reader();

    var pipes = std.AutoHashMap(Point, u8).init(allocator);
    var start: Point = undefined;
    var col: u32 = 0;
    var row: u32 = 0;

    while (true) {
        const c = inStream.readByte() catch break;
        switch (c) {
            '|', '-', 'L', 'J', '7', 'F', 'S' => {
                if (c == 'S') start = .{ .x = col, .y = row };
                try pipes.put(.{ .x = col, .y = row }, c);
                col += 1;
            },
            '\n' => {
                row += 1;
                col = 0;
            },
            else => col += 1,
        }
    }

    return .{ .start = start, .pipes = &pipes };
}

pub fn main() !void {
    const input = try parse();
    const pipeDirections = try pipeDirectionsMap();

    var startPipe: u8 = if (input.pipes.get(input.start.add(.north)) != null) '|' else '-';
    try input.pipes.put(input.start, startPipe);

    var visited = std.AutoHashMap(Point, void).init(allocator);
    defer visited.deinit();

    var polygon = std.ArrayList(Point).init(allocator);
    defer polygon.deinit();

    var current = input.start;
    while (!visited.contains(current)) {
        try visited.put(current, {});

        if (input.pipes.get(current)) |c| {
            if (pipeDirections.get(c)) |pipe| {
                if (c != '-' and c != '|') try polygon.append(current);

                current = for (pipe) |direction| {
                    const next = current.add(direction);
                    if (!visited.contains(next)) break next;
                };
            }
        }
    }

    const partA = visited.count() / 2;
    const partB = numInnerPoints(polygon.items, visited.count());

    std.debug.print("part a: {d}\npart b: {d}\n", .{ partA, partB });
}
