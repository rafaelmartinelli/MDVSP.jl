using MDVSP
using Graphs
using JuMP
using Gurobi
using Printf

const EPS = 1e-5

include("Solution.jl")
include("TopologicalSort.jl")
include("CompactFormulation.jl")
include("Constructive.jl")
include("decomposition/MasterFormulation.jl")
include("decomposition/Pricing.jl")
include("decomposition/ColumnGeneration.jl")

instance_name = "n50m2s0"
algo_type = :ColumnGeneration

data = loadMDVSP(instance_name)
println(data)

if algo_type == :CompactFormulation
    algo = CompactFormulation(data)
elseif algo_type == :Constructive
    algo = Constructive(data)
elseif algo_type == :ColumnGeneration
    algo = ColumnGeneration(data)
else
    error("Unknown algorithm.")
end

routes, red_cost = solve!(algo)
