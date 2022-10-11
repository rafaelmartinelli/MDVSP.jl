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

    return Data(depots, tasks, vertices, vehicles, costs, name, loadBounds(name)...)
end

function loadBounds(name::String)
    file_name = joinpath(data_path, "bounds.txt")
    values = split(read(file_name, String))

    index = findfirst(isequal(name), values)
    if index !== nothing
        return parse(Int64, values[index + 1]), parse(Int64, values[index + 2])
    else
        return 0, 0
    end
end
