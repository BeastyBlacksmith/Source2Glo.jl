using Nettle

function parse_file(config_file)
    local x
    open( config_file ) do io
        x = JSON.parse(io)
    end
    for key in keys(x)
        setproperty(configuration, key, getproperty(x, key))
    end
    return nothing
end # function

function write_file(config_file, x)
    open( config_file, "w" ) do io
        JSON.print( io, x )
    end # do
    return nothing
end # function

function register( path )
    if path ∈ configuration["paths"]
        return
    end
    push!(configuration["paths"], path)
    return nothing
end # function

function unregister( path )
    path_ind = findfirst(path, configuration["paths"])
    if path_ind === nothing
        @info "Path $path not found.\nRegistered paths are:\n$(configuration["paths"])"
        return
    end
    deleteat!( configuration["paths"], path_ind )
    return nothing
end # function

function reset_paths()
    configuration["paths"] = String[]
    return nothing
end # function

# FIXME: ...
function default_header(; dec = dec)
    token = String( trim_padding_PKCS5(decrypt( dec, Vector{UInt8}( configuration["token"] ) )) )
    ["Content-Type" => "application/json", "Accept" => "application/json", "Authorization" => token]
end # function

function add_token( pat; enc = enc )
    @show pat
    configuration["token"] = String( encrypt(enc, add_padding_PKCS5(Vector{UInt8}(pat),16) ) )
    return nothing
end # function
