using MDVSP

using JuMP
using Gurobi

function main()
    data = loadMDVSP("m4n500s0")

    V = data.vertices
    D = data.depots
    T = data.tasks
    c = data.costs
    m = data.vehicles

    model = Model(Gurobi.Optimizer)

    @variable(model, x[i in V, j in V, d in D; existsArc(D, c, i, j, d)], Bin)

    @objective(model, Min, sum(c[i, j]x[i, j, d] for i in V, j in V, d in D if existsArc(D, c, i, j, d)))

    @constraint(model, from[i in T], sum(x[i, j, d] for j in V, d in D if existsArc(D, c, i, j, d)) == 1)
    @constraint(model, to[j in T], sum(x[i, j, d] for i in V, d in D if existsArc(D, c, i, j, d)) == 1)
    @constraint(model, dep[d in D], sum(x[d, j, d] for j in T if existsArc(D, c, d, j, d)) == 
        sum(x[i, d, d] for i in T if existsArc(D, c, i, d, d)))
    @constraint(model, veh[d in D], sum(x[d, j, d] for j in T if existsArc(D, c, d, j, d)) <= m[d])

    write_to_file(model, "model.lp")
    optimize!(model)
    println(termination_status(model))

    println("z = ", objective_value(model))
end

function existsArc(D::Vector{Int64}, c::Matrix{Int64}, i::Int64, j::Int64, d::Int64)
    return c[i, j] != -1 && (i > length(D) || i == d) && (j > length(D) || j == d)
end

main()
