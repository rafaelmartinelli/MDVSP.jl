function loadMDVSP(name::String)
    real_name = name * ".inp"
    zip_name = name * ".zip"
    abs_zip_name = joinpath(data_path, zip_name)
    if !isfile(abs_zip_name)
        regex = r"m(\d+)n(\d+)s(\d+)"
        regex_values = match(regex, name)
        if regex_values === nothing || length(regex_values) < 2
            @error("Unknown instance: $name")
            return nothing
        end

        zip_name = "Mdvsp_" * regex_values[1] * "dep_" * regex_values[2] * "trips.zip"
        abs_zip_name = joinpath(data_path, zip_name)
        if !isfile(abs_zip_name)
            if !downloadFile(zip_name) return nothing end
        end
    end

    zip_file = ZipFile.Reader(abs_zip_name)
    pos = findfirst(x -> x.name == real_name, zip_file.files)
    if pos === nothing
        close(zip_file)
        @error("Instance $real_name not found in zip file $zip_name")
        return nothing
    end
    
    raw = split(read(zip_file.files[pos], String))
    close(zip_file)
    return parseData(name, raw)
end

function parseData(name::String, raw::Vector{SubString{String}})
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
        return 0, typemax(Int64)
    end
end
