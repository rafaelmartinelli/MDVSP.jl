# To run:
#   1. Open Julia terminal (Alt + j, Alt + o)
#   2. Activate test with "] activate test"
#   3. Run the source file

using MDVSP
using Graphs

instance_name = "m4n500s1"

function topSort(G::SimpleDiGraph, node::Int64, marked::Vector{Bool}, res::Vector{Int64})
    if marked[node] return end
    marked[node] = true
    for n in outneighbors(G, node)
        topSort(G, n, marked, res)
    end
    push!(res, node)
end

function topSort(G::SimpleDiGraph)
    marked = zeros(Bool, length(data.vertices))
    res = []
    for i in data.vertices
        if marked[i] continue end
        topSort(G, i, marked, res)
    end
    return reverse(res)
end

function buildGraph(data::Data)
    G = SimpleDiGraph(length(data.vertices))
    for i in data.vertices
        for j in data.vertices
            if data.costs[i, j] != -1 && i ∉ data.depots && j ∉ data.depots
                add_edge!(G, i, j)
            end
        end
    end

    return G
end

function constructive(data::Data, G::SimpleDiGraph)
    solution = []
    vehicles = zeros(Int64, length(data.depots))

    total = 0
    nodes = topSort(G)
    while length(nodes) > 0
        depot = 0
        for d in data.depots
            if vehicles[d] == data.vehicles[d] continue end
            if data.costs[d, nodes[1]] == -1 continue end
            if depot == 0 || data.costs[d, nodes[1]] < data.costs[depot, nodes[1]]
                depot = d
            end
        end
        if depot == 0 break end
        vehicles[depot] += 1

        route = [ depot ]
        notUsed = Vector{Int64}()
        for n in nodes
            if data.costs[route[end], n] != -1 && n ∉ data.depots
                total += data.costs[route[end], n]
                push!(route, n)
            else
                push!(notUsed, n)
            end
        end
        total += data.costs[route[end], depot]
        push!(route, depot)
        push!(solution, route)

        nodes = deepcopy(notUsed)
    end

    return total, solution
end

data = loadMDVSP(instance_name)
total, solution = main(data)
