mutable struct MasterFormulation
    data::Data
    model::JuMP.Model
    routes::Vector{Vector{Route}}
    solution::Solution
    is_integral::Bool

    function MasterFormulation(data::Data, routes::Vector{Vector{Route}}, is_integral::Bool = false)
        new(data, buildModel(data, routes, is_integral), routes, Solution(), is_integral)
    end
end

function buildModel(data::Data, routes::Vector{Vector{Route}}, is_integral::Bool)
    D = data.depots
    T = data.tasks
    R = [ collect(1:length(route)) for route in routes ]

    model = Model(Gurobi.Optimizer)

    if is_integral
        @variable(model, λ[d in D, r in R[d]], Bin)
    else
        @variable(model, λ[d in D, r in R[d]] >= 0)
    end
    @objective(model, Min, sum(routes[d][r].cost * λ[d, r] for d in D, r in R[d]))
    @constraint(model, task[t in T], sum(λ[d, r] for d in D, r in R[d] if t in routes[d][r].vertices) == 1)
    @constraint(model, depot[d in D], sum(λ[d, r] for r in R[d]) <= data.vehicles[d])

    return model
end

function solve!(master::MasterFormulation)
    set_silent(master.model)
    optimize!(master.model)

    if termination_status(master.model) != OPTIMAL
        error("The model was not solved correctly.")
        return
    end

    if master.is_integral
        sol_routes = [ Route[] for _ in master.data.depots ]
        for d in master.data.depots
            for r in 1:length(master.routes[d])
                if value(master.model[:λ][d, r]) > 10e-5
                    push!(sol_routes[d], master.routes[d][r])
                end
            end
        end
        master.solution = Solution(round(Int64, objective_value(master.model)), sol_routes)
        println("Master => ", master.solution)
    else
        @printf("Master = %.2f\n", objective_value(master.model))
    end
end

function getDuals(master::MasterFormulation)
    π = zeros(Float64, length(master.data.vertices))
    for v in master.data.vertices
        if isDepot(master.data, v)
            π[v] = dual(master.model[:depot][v])
        else
            π[v] = dual(master.model[:task][v])
        end
    end

    return π
end

function add!(master::MasterFormulation, routes::Vector{Vector{Route}})
    for d in master.data.depots
        append!(master.routes[d], routes[d])
    end
    master.model = buildModel(master.data, master.routes, false)
end
