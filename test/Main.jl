using MDVSP
using Graphs
using JuMP
using Gurobi

include("Solution.jl")
include("Constructive.jl")
include("decomposition/Master.jl")

instance_name = "m4n500s0"

data = loadMDVSP(instance_name)
println(data)

graph = buildGraph(data)
solution = constructive(data, graph)
println("Constructive = ", solution)

model = buildModel(data, solution.routes)
set_silent(model)
optimize!(model)
println("z = ", objective_value(model))
