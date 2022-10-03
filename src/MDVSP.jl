module MDVSP

export Data, loadMDVSP

const data_path = joinpath(pkgdir(MDVSP), "data")

include("Data.jl")
include("Loader.jl")

end
