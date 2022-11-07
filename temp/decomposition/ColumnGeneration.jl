mutable struct ColumnGeneration
    data::Data
    master::MasterFormulation
    pricing::Pricing

    function ColumnGeneration(data::Data)
        constructive = Constructive(data)
        solve!(constructive)
    
        master = MasterFormulation(data, constructive.solution.routes)
        pricing = Pricing(data)
    
        return new(data, master, pricing)
    end
end

function solve!(col_gen::ColumnGeneration)
    while true
        solve!(col_gen.master)

        duals = getDuals(col_gen.master)
        routes, red_cost = solve!(col_gen.pricing, duals)

        println("Best RC = ", red_cost)

        if red_cost > -EPS break end

        add!(col_gen.master, routes)
    end

    col_gen.master.model = buildModel(col_gen.data, col_gen.master.routes, true)
    solve!(col_gen.master)
end
