function buildGraph(data::Data)
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

function constructive(data::Data, graph::SimpleDiGraph)
    routes = [ Vector{Route}() for _ in data.depots ]
    vehicles = zeros(Int64, length(data.depots))

    id = 0
    total_cost = 0
    top_sort = topological_sort_by_dfs(graph)
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

        id += 1
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
        push!(routes[depot], Route(id, cost, vertices))

        total_cost += cost
        top_sort = deepcopy(not_used)
    end

    return Solution(total_cost, routes)
end
