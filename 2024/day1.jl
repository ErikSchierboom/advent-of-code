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
    @testset "sample" begin
        part_1, part_2 = solve(IOBuffer(sample))
        @test part_1 == 11
        @test part_2 == 31
    end

    @testset "input" begin
        part_1, part_2 = solve()
        @test part_1 == 2196996
        @test part_2 == 23655822
    end
end
