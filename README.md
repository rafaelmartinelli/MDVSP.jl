# MDVSP.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://rafaelmartinelli.github.io/MDVSP.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://rafaelmartinelli.github.io/MDVSP.jl/dev)
[![Build Status](https://github.com/rafaelmartinelli/MDVSP.jl/workflows/CI/badge.svg)](https://github.com/rafaelmartinelli/MDVSP.jl/actions)
[![Coverage](https://codecov.io/gh/rafaelmartinelli/MDVSP.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/rafaelmartinelli/MDVSP.jl)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

This package reads data files in `inp` format for Multi-Depot Vechile Scheduling Problem (MDVSP) instances.

## Usage

The type used by the package is `Data`, defined as follows:

```julia
struct Data
    depots::Vector{Int64}   # Depots' indexes (in sequence)
    tasks::Vector{Int64}    # Tasks' indexes (in sequence)
    vertices::Vector{Int64} # All indexes
    vehicles::Vector{Int64} # Number of vehicles in each depot
    costs::Matrix{Int64}    # Costs (times) from each pair of tasks

    name::String            # Instance name

    lb::Int64               # Lower bound (0 if not known)
    ub::Int64               # Upper bound (type_max(Int64) if not known)
end
```

Some toy MDVSP instances are preloaded. See the [full list](https://github.com/rafaelmartinelli/MDVSP.jl/tree/main/data).
Classical MDVSP instances from the literature are downloaded on demand from [this site](https://personal.eur.nl/huisman/instances.htm).
For example, to load MDVSP instance `m4n500s0`:

```julia
data = loadMDVSP("m4n500s0")
```

The package still does not load custom MDVSP instances.

## Installation

MDVSP is _not_ a registered Julia Package...
You can install MDVSP through the Julia package manager.
Open Julia's interactive session (REPL) and type:

```julia
] add https://github.com/rafaelmartinelli/MDVSP.jl
```

## Related links

- [Dennis Huisman's MDVSP page](https://personal.eur.nl/huisman/instances.htm)

## Other packages

- [KnapsackLib.jl](https://github.com/rafaelmartinelli/Knapsacks.jl): Knapsack algorithms in Julia
- [FacilityLocationProblems.jl](https://github.com/rafaelmartinelli/FacilityLocationProblems.jl): Facility Location Problems Lib
- [AssignmentProblems.jl](https://github.com/rafaelmartinelli/AssignmentProblems.jl): Assignment Problems Lib
- [BPPLib.jl](https://github.com/rafaelmartinelli/BPPLib.jl): Bin Packing and Cutting Stock Problems Lib
- [CARPData.jl](https://github.com/rafaelmartinelli/CARPData.jl): Capacitated Arc Routing Problem Lib
- [CVRPLIB.jl](https://github.com/chkwon/CVRPLIB.jl): Capacitated Vehicle Routing Problem Lib
- [TSPLIB.jl](https://github.com/matago/TSPLIB.jl): Traveling Salesman Problem Lib
