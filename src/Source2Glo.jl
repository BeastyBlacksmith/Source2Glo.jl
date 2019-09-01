module Source2Glo

using JSON
const config_file = "config.json"
include("configuration.jl")

function __init__()
    if (!isfile)(config_file)
        write_file(config_file, :paths=>String[])
    else
        x = parse_file(config_file)
        if haskey(x, "paths")
            return
        end
        write_file(config_file, :paths=>String[])
    end
end # function
end # module
