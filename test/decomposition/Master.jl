function buildModel(data::Data, routes::Vector{Vector{Route}}, is_integral::Bool = true)
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
    @constraint(model, [t in T], sum(λ[d, r] for d in D, r in R[d] if t in routes[d][r].vertices) == 1)
    @constraint(model, [d in D], sum(λ[d, r] for r in R[d]) <= data.vehicles[d])

    return model
end
