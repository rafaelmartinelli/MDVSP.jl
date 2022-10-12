using MDVSP
using Test

@testset "LoadLocal" begin
    data = loadMDVSP("n50m2s0")
    @test length(data.depots) == 2
    @test data.depots[1] == 1
    @test length(data.tasks) == 50
    @test data.tasks[10] == 12
    @test length(data.vertices) == 52
    @test data.vertices[50] == 50
    @test length(data.vehicles) == length(data.depots)
    @test data.vehicles[1] == 15
    @test size(data.costs) == (52, 52)
    @test data.costs[20, 44] == 423
    @test data.name == "n50m2s0"
    @test data.lb == 0
    @test data.ub == typemax(Int64)
    @test_nowarn println(data)
end

@testset "LoadRemote" begin
    data = loadMDVSP("m4n500s0")
    @test length(data.depots) == 4
    @test data.depots[1] == 1
    @test length(data.tasks) == 500
    @test data.tasks[10] == 14
    @test length(data.vertices) == 504
    @test data.vertices[50] == 50
    @test length(data.vehicles) == length(data.depots)
    @test data.vehicles[1] == 62
    @test size(data.costs) == (504, 504)
    @test data.costs[20, 44] == 484
    @test data.name == "m4n500s0"
    @test data.lb == 1289114
    @test data.ub == 1289114
    @test_nowarn println(data)
end

@testset "ErrorLocal" begin
    data = loadMDVSP("notaninstance")
    @test data === nothing
end

@testset "ErrorRemote" begin
    data = loadMDVSP("m4n5000s0")
    @test data === nothing
end

@testset "ErrorZip" begin
    data = loadMDVSP("m4n500s10")
    @test data === nothing
end
