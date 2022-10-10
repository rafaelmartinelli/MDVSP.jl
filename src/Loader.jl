function loadMDVSP(name::String)
    raw = split(read(joinpath(data_path, name * ".inp"), String))

    num_depots = parse(Int64, raw[1])
    depots = collect(1:num_depots)

    num_tasks = parse(Int64, raw[2])
    tasks = collect((num_depots + 1):(num_tasks + num_depots))

    num_vertices = num_depots + num_tasks
    vertices = collect(1:num_vertices)

    vehicles = parse.(Int64, raw[3:(num_depots + 2)])
    costs = parse.(Int64, raw[(num_depots + 3):end])
    costs = transpose(reshape(costs, num_vertices, num_vertices))

    return Data(depots, tasks, vertices, vehicles, costs, name, 0, 0)
end

function loadBounds(name::String)
    return 0, typemax(Int64)
end
