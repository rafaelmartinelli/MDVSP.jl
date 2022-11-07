mutable struct CompactFormulation
    data::Data
    model::JuMP.Model
    solution::Solution

    function CompactFormulation(data::Data)
        return new(data, buildCompactFormulation(data), Solution())
    end
end

function buildCompactFormulation(data::Data)
    D = data.depots
    T = data.tasks
    c = data.costs
    m = data.vehicles

    model = Model(Gurobi.Optimizer)

    @variable(model, x[arcs(data)], Bin)

    @objective(model, Min, sum(c[a.from, a.to]x[a] for a in arcs(data)))

    @constraint(model, from[i in T], sum(x[a] for a in arcsFrom(data, i)) == 1)
    @constraint(model, veh[d in D], sum(x[a] for a in taskArcsFrom(data, d, d)) <= m[d])
    @constraint(model, flow[d in D, i in T], sum(x[a] for a in arcsFrom(data, d, i)) == sum(x[a] for a in arcsTo(data, d, i)))

    return model
end

function solve!(formulation::CompactFormulation)
    # write_to_file(model, instance_name * ".lp")
    set_optimizer_attribute(formulation.model, "TimeLimit", 600)
    set_optimizer_attribute(formulation.model, "MIPGap", 1e-6)
    optimize!(formulation.model)
    
    status = termination_status(formulation.model)
    if status == OPTIMAL
        formulation.solution = buildSolution!(formulation)
        println("Compact formulation => ", formulation.solution)
    elseif status == TIME_LIMIT
        @printf("z = [%.3f, %.3f]\n", objective_bound(formulation.model), objective_value(formulation.model))
    else
        error("The model was not solved correctly.")
    end
end

function buildSolution!(formulation::CompactFormulation)
    sol_arcs = Dict(a => true for a in arcs(data) if value(formulation.model[:x][a]) > EPS)

    total_cost = 0
    sol_routes = [ Route[] for _ in formulation.data.depots ]
    
    for d in data.depots
        for a in arcsFrom(data, d, d)
            if get(sol_arcs, a, false)
                last = a.to
                cost = formulation.data.costs[d, last]
                vertices = [ d, last ]
                while last != d
                    found = false
                    for a2 in arcsFrom(data, d, last)
                        if get(sol_arcs, a2, false)
                            cost += formulation.data.costs[last, a2.to]
                            push!(vertices, a2.to)
                            last = a2.to
                            found = true
                            break
                        end
                    end
                    if !found error("Error!") end
                end

                total_cost += cost
                push!(sol_routes[d], Route(cost, vertices))
            end
        end
    end

    return Solution(total_cost, sol_routes)
end
