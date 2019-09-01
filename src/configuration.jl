function register( path; config = config_file )
    local x
    open( config_file ) do io
        x = JSON.parse(io)
    end
    if path ∈ x["paths"]
        return
    end
    push!(x["paths"], path)
    open( config_file, "w" ) do io
        JSON.print( io, x )
    end # do
end # function
