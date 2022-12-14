struct Data
    depots::Vector{Int64}
    tasks::Vector{Int64}
    vertices::Vector{Int64}
    vehicles::Vector{Int64}
    costs::Matrix{Int64}

    name::String

    lb::Int64
    ub::Int64
end

function Base.show(io::IO, data::Data)
    print(io, "MDVSP Data ", data.name)
    print(io, " (", length(data.depots)," depots,")
    print(io, " ", length(data.tasks), " tasks)")
    print(io, " [", data.lb, ", ", data.ub == typemax(Int64) ? "Inf" : data.ub, "]")
end

struct Arc
    depot::Int64
    from::Int64
    to::Int64
end

function Base.show(io::IO, arc::Arc)
    print(io, "(", arc.depot, ", ", arc.from, ", ", arc.to, ")")
end
