module MDVSP

export Data, Arc, loadMDVSP
export isDepot, existsArc
export arcs, arcsFrom, arcsTo
export taskArcs, taskArcsFrom, taskArcsTo

const data_path = joinpath(pkgdir(MDVSP), "data")
const Arc = Tuple{Int64, Int64, Int64}

include("Data.jl")
include("Loader.jl")
include("Helpers.jl")

end
