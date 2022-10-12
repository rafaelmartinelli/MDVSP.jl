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

@testset "Arcs and Helpers" begin
    data = loadMDVSP("n50m2s0")
    println(Arc(1, 20, 44))
    
    @test isDepot(data, 1) == true
    @test isDepot(data, 3) == false

    @test existsArc(data, 1, 20, 44) == true
    @test existsArc(data, 1, 44, 20) == false
    @test existsArc(data, Arc(1, 20, 44)) == true
    @test existsArc(data, Arc(1, 44, 20)) == false

    all_arcs = collect(arcs(data))
    @test length(all_arcs) == 1500
    @test all_arcs[1234] == Arc(2, 37, 44)

    depot_arcs = collect(arcs(data, 1))
    @test length(depot_arcs) == 750
    @test depot_arcs[436] == Arc(1, 16, 31)

    task_arcs = collect(taskArcs(data))
    @test length(task_arcs) == 1300
    @test task_arcs[1111] == Arc(1, 35, 46)

    depot_task_arcs = collect(taskArcs(data, 2))
    @test length(depot_task_arcs) == 650
    @test depot_task_arcs[321] == Arc(2, 48,27)

    from_arcs = collect(arcsFrom(data, 24))
    @test length(from_arcs) == 20
    @test from_arcs[20] == Arc(2, 24, 52)

    depot_from_arcs = collect(arcsFrom(data, 1, 26))
    @test length(depot_from_arcs) == 1
    @test depot_from_arcs[1] == Arc(1, 26, 1)

    task_from_arcs = collect(taskArcsFrom(data, 37))
    @test length(task_from_arcs) == 14
    @test task_from_arcs[11] == Arc(1, 37, 44)

    depot_task_from_arcs = collect(taskArcsFrom(data, 1, 48))
    @test length(depot_task_from_arcs) == 3
    @test depot_task_from_arcs[2] == Arc(1, 48, 27)

    to_arcs = collect(arcsTo(data, 12))
    @test length(to_arcs) == 24
    @test to_arcs[12] == Arc(2, 30, 12)

    depot_to_arcs = collect(arcsTo(data, 2, 32))
    @test length(depot_to_arcs) == 12
    @test depot_to_arcs[6] == Arc(2, 30, 32)

    task_to_arcs = collect(taskArcsTo(data, 46))
    @test length(task_to_arcs) == 40
    @test task_to_arcs[13] == Arc(1, 17, 46)

    depot_task_to_arcs = collect(taskArcsTo(data, 2, 42))
    @test length(depot_task_to_arcs) == 1
    @test depot_task_to_arcs[1] == Arc(2, 35, 42)
end
