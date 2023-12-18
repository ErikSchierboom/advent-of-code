const std = @import("std");
const allocator = std.heap.page_allocator;

const Point = struct { x: u32, y: u32 };
const Delta = struct { dx: i8, dy: i8 };

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

fn pipesMap() !std.AutoHashMap(u8, [2]Delta) {
    var pipes = std.AutoHashMap(u8, [2]Delta).init(allocator);
    try pipes.put('|', [_]Delta{ .{ .dx = 0, .dy = 1 }, .{ .dx = 0, .dy = -1 } });
    try pipes.put('-', [_]Delta{ .{ .dx = -1, .dy = 0 }, .{ .dx = 1, .dy = 0 } });
    try pipes.put('L', [_]Delta{ .{ .dx = 0, .dy = -1 }, .{ .dx = 1, .dy = 0 } });
    try pipes.put('J', [_]Delta{ .{ .dx = 0, .dy = -1 }, .{ .dx = -1, .dy = 0 } });
    try pipes.put('7', [_]Delta{ .{ .dx = -1, .dy = 0 }, .{ .dx = 0, .dy = 1 } });
    try pipes.put('F', [_]Delta{ .{ .dx = 1, .dy = 0 }, .{ .dx = 0, .dy = 1 } });
    return pipes;
}

fn parse() ![][]u8 {
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var lines = std.ArrayList([]u8).init(allocator);

    while (true) {
        var line = std.ArrayList(u8).init(allocator);
        var writer = line.writer();

        in_stream.streamUntilDelimiter(writer, '\n', null) catch |err| {
            switch (err) {
                error.EndOfStream => {
                    try lines.append(line.items);
                    break;
                },
                else => return err,
            }
        };

        try lines.append(line.items);
    }

    return lines.items;
}

pub fn main() !void {
    const lines = try parse();

    const rows = lines.len;
    const cols = lines[0].len;

    var start: Point = undefined;

    for (lines, 0..) |line, row| {
        for (line, 0..) |char, col| if (char == 'S') {
            start = .{ .x = @intCast(col), .y = @intCast(row) };
        };
    }

    var neighbors = .{
        .above = if (start.y == 0) null else lines[start.y - 1][start.x],
        .below = if (start.y >= rows - 1) null else lines[start.y + 1][start.x],
        .left = if (start.x == 0) null else lines[start.y][start.x - 1],
        .right = if (start.x >= cols - 1) null else lines[start.y][start.x + 1],
    };

    if (neighbors.above == '|' and neighbors.below == '|') {
        lines[start.y][start.x] = '|';
    } else if (neighbors.above == '7' and neighbors.below == '|') {
        lines[start.y][start.x] = '|';
    } else if (neighbors.above == 'F' and neighbors.below == '|') {
        lines[start.y][start.x] = '|';
    } else if (neighbors.left == '-' and neighbors.right == '-') {
        lines[start.y][start.x] = '-';
    } else if (neighbors.left == '-' and neighbors.right == 'J') {
        lines[start.y][start.x] = '-';
    } else if (neighbors.left == 'F' and neighbors.right == '-') {
        lines[start.y][start.x] = '-';
    } else if (neighbors.above == '|' and neighbors.right == '-') {
        lines[start.y][start.x] = 'L';
    } else if (neighbors.above == '|' and neighbors.right == '7') {
        lines[start.y][start.x] = 'L';
    } else if (neighbors.above == '|' and neighbors.left == '-') {
        lines[start.y][start.x] = 'J';
    } else if (neighbors.above == '|' and neighbors.left == 'F') {
        lines[start.y][start.x] = 'J';
    } else if (neighbors.below == '|' and neighbors.left == '-') {
        lines[start.y][start.x] = '7';
    } else if (neighbors.below == '|' and neighbors.left == 'L') {
        lines[start.y][start.x] = '7';
    } else if (neighbors.below == '|' and neighbors.right == '-') {
        lines[start.y][start.x] = 'F';
    } else if (neighbors.below == '|' and neighbors.right == 'J') {
        lines[start.y][start.x] = 'F';
    }

    var points = std.AutoHashMap(Point, void).init(allocator);
    defer points.deinit();

    var polygon = std.ArrayList(Point).init(allocator);
    defer polygon.deinit();

    const pipes = try pipesMap();

    var current = start;
    while (!points.contains(current)) {
        try points.put(current, {});

        const c = lines[current.y][current.x];
        if (pipes.get(c)) |pipe| {
            if (c != '-' and c != '|') try polygon.append(current);

            current = for (pipe) |delta| {
                const nextX: u32 = @intCast(@as(i64, current.x) + delta.dx);
                const nextY: u32 = @intCast(@as(i64, current.y) + delta.dy);
                const next: Point = .{ .x = nextX, .y = nextY };
                if (!points.contains(next)) break next;
            };
        }
    }

    const partA = points.count() / 2;
    const partB = numInnerPoints(polygon.items, points.count());

    std.debug.print("part a: {d}\npart b: {d}\n", .{ partA, partB });
}
