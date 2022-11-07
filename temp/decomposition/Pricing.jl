struct Pricing
    data::Data
    top_sort::Vector{Int64}

    function Pricing(data::Data)
        return new(data, getTopologicalSort(data))
    end
end

function solve!(pricing::Pricing, duals::Vector{Float64})
    routes = [ Route[] for _ in pricing.data.depots ]
    best_red_cost = 0.0

    for d in pricing.data.depots
        red_costs = zeros(Float64, length(pricing.data.vertices))
        parents = collect(1:length(pricing.data.vertices))

        for t in pricing.data.tasks
            red_costs[t] = pricing.data.costs[d, t] - duals[d] - duals[t]
            parents[t] = d
        end

        for t in pricing.top_sort
            if isDepot(pricing.data, t) continue end
            for t2 in pricing.data.tasks
                if pricing.data.costs[t, t2] == -1 continue end

                new_red_cost = red_costs[t] + pricing.data.costs[t, t2] - duals[t2]
                if new_red_cost - red_costs[t2] < -EPS
                    red_costs[t2] = new_red_cost
                    parents[t2] = t
                end
            end
        end

        routes_red_costs = Float64[]
        for t in pricing.data.tasks
            new_red_cost = red_costs[t] + pricing.data.costs[t, d]
            if new_red_cost < -EPS
                vertices = [ t ]
                cost = 0

                current = t
                parent = parents[t]
                while parent != current
                    cost += pricing.data.costs[parent, current]
                    push!(vertices, parent)
                    current = parent
                    parent = parents[current]
                end
                reverse!(vertices)
                
                cost += pricing.data.costs[vertices[end], d]
                push!(vertices, d)

                push!(routes[d], Route(cost, vertices))
                push!(routes_red_costs, new_red_cost)
            end

            if new_red_cost - best_red_cost < -EPS
                best_red_cost = new_red_cost
            end
        end

        indexes = sortperm(routes_red_costs)
        new_routes = Route[]
        for r in 1:length(routes[d])
            if indexes[r] <= 20
                push!(new_routes, routes[d][r])
            end
        end
        routes[d] = new_routes
    end

    return routes, best_red_cost
end
