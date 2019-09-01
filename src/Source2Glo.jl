module Source2Glo

using JSON
const config_file = "config.json"
include("configuration.jl")

function __init__()
    if (!isfile)(config_file)
        open(config_file, "w") do io
            JSON.print(io, :paths=>String[])
        end
    else
        local x
        open( config_file ) do io
            x = JSON.parse(io)
        end
        if haskey(x, "paths")
            return
        end
        open(config_file, "w") do io
            JSON.print(io, :paths=>String[])
        end
    end
end # function
end # module
