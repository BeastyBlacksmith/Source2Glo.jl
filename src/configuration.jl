function parse_file(file)
    local x
    open( config_file ) do io
        x = JSON.parse(io)
    end
    return x
end # function

function write_file(file, x)
    open( config_file, "w" ) do io
        JSON.print( io, x )
    end # do
end # function

function register( path; config_file = config_file )
    x = parse_file(config_file)
    if path ∈ x["paths"]
        return
    end
    push!(x["paths"], path)
    write_file(config_file, x)
end # function
function unregister( path; config_file = config_file )
    x = parse_file(config_file)
    path_ind = findfirst(path, x["paths"])
    if path_ind === nothing
        @info "Path $path not found.\nRegistered paths are:\n$(x["paths"])"
        return
    end
    deleteat!( x["paths"], path_ind )
    write_file(config_file, x)
end # function
