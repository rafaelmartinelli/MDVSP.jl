# To run:
#   1. Open Julia terminal (Alt + j, Alt + o)
#   2. Activate test with "] activate test"
#   3. Run the source file

using MDVSP

using JuMP
using Gurobi

using Printf

const EPS = 1e-5
instance_name = "m4n500s0"

function main(data::Data)
    D = data.depots
    T = data.tasks
    c = data.costs
    m = data.vehicles

    model = Model(Gurobi.Optimizer)

    @variable(model, x[arcs(data)], Bin)

    @objective(model, Min, sum(c[i, j]x[(d, i, j)] for (d, i, j) in arcs(data)))

    @constraint(model, from[i in T], sum(x[a] for a in arcsFrom(data, i)) == 1)
    @constraint(model, veh[d in D], sum(x[a] for a in taskArcsFrom(data, d, d)) <= m[d])
    @constraint(model, flow[d in D, i in T], sum(x[a] for a in arcsFrom(data, d, i)) == sum(x[a] for a in arcsTo(data, d, i)))

    # write_to_file(model, instance_name * ".lp")
    set_optimizer_attribute(model, "MIPGap", 1e-6)
    optimize!(model)
    println(termination_status(model))

    @printf("UB = %.3f\n", objective_value(model))
    @printf("LB = %.3f\n", objective_bound(model))

    sol = Dict(a => true for a in arcs(data) if value(x[a]) > EPS)
    return sol
end

function printSolution(data::Data, sol::Dict{Arc, Bool})
    for d in data.depots
        println("Depot $d:")
        for a in arcsFrom(data, d, d)
            if get(sol, a, false)
                last = a[3]
                print(d, " ", last)
                while last != d
                    found = false
                    for a2 in arcsFrom(data, d, last)
                        if get(sol, a2, false)
                            last = a2[3]
                            print(" ", last)
                            found = true
                            break
                        end
                    end
                    if !found error("Error!") end
                end
                println()
            end
        end
    end
end

data = loadMDVSP(instance_name)
sol = main(data)
printSolution(data, sol)
