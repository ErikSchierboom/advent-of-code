using DelimitedFiles, StatsBase, Test

part_1(ids) = sum(abs, ids[:, begin] - ids[:, end])

function part_2(ids)
    counts = countmap(ids[:, end])
    sum(id * get(counts, id, 0) for id=ids[:, begin])
end

function solve(input=joinpath(@__DIR__, "day1.txt"))
    ids = sort(readdlm(input, Int8); dims=1)
    return part_1(ids), part_2(ids)
end

const sample = """
               3   4
               4   3
               2   5
               1   3
               3   9
               3   3
               """

function test()
    part_1_sample, part_2_sample = solve(IOBuffer(sample))
    part_1, part_2 = solve()

    @testset "part 1" begin
        @test part_1_sample == 11
        @test part_1 == 2196996
    end

    @testset "part 2" begin
        @test part_2_sample == 31
        @test part_2 == 23655822
    end
end
