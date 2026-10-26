using DelimitedFiles, StatsBase, Test

parse_input(input) = sort(readdlm(input, Int); dims=1)

part_1(location_ids) = sum(abs, location_ids[:, begin] - location_ids[:, end])

function part_2(location_ids)
    counts = countmap(location_ids[:, end])
    sum(location_id * get(counts, location_id, 0) for location_id in location_ids[:, begin])
end

const sample = parse_input(IOBuffer(
    """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """))

const file = parse_input("input/01.txt")

function test()
    @testset "part_1" begin
        @test part_1(sample) == 11
        @test part_1(file) == 2196996
    end

    @testset "part_2" begin
        @test part_2(sample) == 31
        @test part_2(file) == 23655822
    end
end
