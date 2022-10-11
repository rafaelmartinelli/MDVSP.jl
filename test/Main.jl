using MDVSP
using Graphs
using JuMP
using Gurobi
using Printf

include("Solution.jl")
include("Constructive.jl")
include("decomposition/MasterFormulation.jl")
include("decomposition/Pricing.jl")
include("decomposition/ColumnGeneration.jl")

instance_name = "m4n500s0"
algo_type = :Constructive

data = loadMDVSP(instance_name)
println(data)

if algo_type == :Constructive
    algo = Constructive(data)
elseif algo_type == :ColumnGeneration
    algo = ColumnGeneration(data)
else
    @error("Unknown algorithm.")
end

solve!(algo)
