function downloadFile(file_name::String)
    url = "https://personal.eur.nl/huisman/" * file_name
    abs_file_name = joinpath(data_path, file_name)
    try
        Downloads.download(url, abs_file_name)
    catch
        @error("File $file_name does not exist in MDVSP page.")
        return false
    end
    return true
end
