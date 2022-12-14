mutable struct Constructive
    data::Data
    graph::SimpleDiGraph
    solution::Solution

    function Constructive(data::Data)
        return new(data, buildGraph(data), Solution())
    end
end

function buildGraph(data::Data)::SimpleDiGraph
    graph = SimpleDiGraph(length(data.vertices))
    for i in data.vertices
        for j in data.vertices
            if data.costs[i, j] != -1 && i ∉ data.depots && j ∉ data.depots
                add_edge!(graph, i, j)
            end
        end
    end

    return graph
end

function solve!(constructive::Constructive)
    routes = [ Vector{Route}() for _ in data.depots ]
    vehicles = zeros(Int64, length(data.depots))

    total_cost = 0
    top_sort = topological_sort_by_dfs(constructive.graph)
    while length(top_sort) > 0
        depot = 0
        for d in data.depots
            if vehicles[d] == data.vehicles[d] continue end
            if data.costs[d, top_sort[1]] == -1 continue end
            if depot == 0 || data.costs[d, top_sort[1]] < data.costs[depot, top_sort[1]]
                depot = d
            end
        end
        if depot == 0 break end
        vehicles[depot] += 1

        cost = 0
        vertices = [ depot ]
        not_used = Vector{Int64}()
        for n in top_sort
            if data.costs[vertices[end], n] != -1 && n ∉ data.depots
                cost += data.costs[vertices[end], n]
                push!(vertices, n)
            else
                push!(not_used, n)
            end
        end
        cost += data.costs[vertices[end], depot]
        push!(vertices, depot)
        push!(routes[depot], Route(cost, vertices))

        total_cost += cost
        top_sort = deepcopy(not_used)
    end

    constructive.solution = Solution(total_cost, routes)
    println("Constructive => ", constructive.solution)
end
