module MDVSP

using Downloads
using ZipFile

export Data, Arc, loadMDVSP
export isDepot, existsArc
export arcs, arcsFrom, arcsTo
export taskArcs, taskArcsFrom, taskArcsTo

const data_path = joinpath(pkgdir(MDVSP), "data")

include("Data.jl")
include("Download.jl")
include("Loader.jl")
include("Helpers.jl")

end
