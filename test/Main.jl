using MDVSP

using JuMP
using Gurobi

using Printf

function main()
    data = loadMDVSP("m4n500s1")

    V = data.vertices
    D = data.depots
    T = data.tasks
    c = data.costs
    m = data.vehicles

    model = Model(Gurobi.Optimizer)

    @variable(model, x[i in V, j in V, d in D; existsArc(D, c, i, j, d)], Bin)

    @objective(model, Min, sum(c[i, j]x[i, j, d] for i in V, j in V, d in D if existsArc(D, c, i, j, d)) + sum(c[i, i] for i in T))

    @constraint(model, veh[d in D], sum(x[d, j, d] for j in T if existsArc(D, c, d, j, d)) <= m[d])
    @constraint(model, from[i in T], sum(x[i, j, d] for j in V, d in D if existsArc(D, c, i, j, d)) == 1)
    @constraint(model, to[j in T], sum(x[i, j, d] for i in V, d in D if existsArc(D, c, i, j, d)) == 1)
    @constraint(model, dep[d in D], sum(x[d, j, d] for j in T if existsArc(D, c, d, j, d)) == 
        sum(x[i, d, d] for i in T if existsArc(D, c, i, d, d)))
    # @constraint(model, flow[i in T, d in D], sum(x[i, j, d] for j in V if existsArc(D, c, i, j, d)) ==
    #     sum(x[j, i, d] for j in V if existsArc(D, c, j, i, d)))

    # write_to_file(model, "model.lp")
    optimize!(model)
    println(termination_status(model))

    @printf("UB = %.3f\n", objective_value(model))
    @printf("LB = %.3f\n", objective_bound(model))

    return data
end

function existsArc(D::Vector{Int64}, c::Matrix{Int64}, i::Int64, j::Int64, d::Int64)
    return c[i, j] != -1 && (!isDepot(D, i) || i == d) && (!isDepot(D, j) || j == d)
end

function isDepot(D::Vector{Int64}, i::Int64)
    return i <= length(D)
end

data = main()
