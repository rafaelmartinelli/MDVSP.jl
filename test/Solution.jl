struct Route
    cost::Int64
    vertices::Vector{Int64}

    function Route(cost::Int64 = 0, vertices::Vector{Int64} = Int64[])
        return new(cost, vertices)
    end
end

function Base.show(io::IO, route::Route)
    print(io,
        "R(d = ", (length(route.vertices) == 0 ? "?" : route.vertices[1]),
        ", c = ", route.cost, ")"
    )
end

struct Solution
    cost::Int64
    routes::Vector{Vector{Route}}

    function Solution(cost::Int64 = 0, routes::Vector{Vector{Route}} = Vector{Vector{Route}}())
        return new(cost, routes)
    end
end

function Base.show(io::IO, solution::Solution)
    print(io,
        "MDVSP Solution (c = ", solution.cost,
        ", ", sum(length.(solution.routes)), " routes)"
    )
end
