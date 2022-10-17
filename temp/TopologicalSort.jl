function getTopologicalSort(data::Data)
    graph = SimpleDiGraph(length(data.vertices))
    for i in data.vertices
        for j in data.vertices
            if data.costs[i, j] != -1 && i ∉ data.depots && j ∉ data.depots
                add_edge!(graph, i, j)
            end
        end
    end
    return topological_sort_by_dfs(graph)
end
