import std.stdio;
import std.file;
import std.array;
import std.algorithm;
import std.range;
import std.conv;

void rotate(T)(T[][] a)
{
    auto N = a.count;
    foreach (i; 0 .. a.count / 2)
    {
        foreach (j; i .. N - i - 1)
        {
            auto temp = a[i][j];
            a[i][j] = a[N - 1 - j][i];
            a[N - 1 - j][i] = a[N - 1 - i][N - 1 - j];
            a[N - 1 - i][N - 1 - j] = a[j][N - 1 - i];
            a[j][N - 1 - i] = temp;
        }
    }
}

void tilt(dchar[][] lines)
{
    auto N = lines.count;
    foreach (x; 0 .. N)
    {
        ulong stopAt = 0;
        foreach (y; 0 .. N)
        {
            switch (lines[y][x])
            {
            case '#':
                stopAt = y + 1;
                break;
            case 'O':
                if (stopAt < y)
                {
                    swap(lines[stopAt][x], lines[y][x]);
                    stopAt++;
                }
                else
                {
                    stopAt = y + 1;
                }
                break;
            default:
                continue;
            }
        }
    }
}

void cycle(dchar[][] lines)
{
    foreach (_; 0 .. 4)
    {
        tilt(lines);
        rotate(lines);
    }
}

int score(dchar[][] lines)
{
    auto sum = 0;
    foreach (y, row; lines)
        sum += (lines.count - y) * row.filter!(c => c == 'O').count;
    return sum;
}

size_t hash(dchar[][] lines)
{
    return reduce!((hash, line) => line.each!(c => hash = (hash * 9) + c))(0, lines);
}

dchar[][] parse()
{
    return readText("input.txt").split.map!(line => line.array).array;
}

void main()
{
    auto part_a_input = parse();
    tilt(part_a_input);

    auto part_b_input = parse();
    int[size_t] cycles;
    foreach (i; 0 .. 1_000_000_000)
    {
        auto hash = hash(part_b_input);
        if (hash in cycles)
        {
            foreach (j; 0 .. (1_000_000_000 - cycles[hash]) % (i - cycles[hash]))
                cycle(part_b_input);
            break;
        }

        cycle(part_b_input);
        cycles[hash] = i;
    }

    writeln("part a: ", score(part_a_input));
    writeln("part b: ", score(part_b_input));
}
