using Nettle

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

function reset_paths(;config_file = config_file)
    x = parse_file(config_file)
    x["paths"] = String[]
    write_file(config_file, x)
end # function

function default_header(; config_file = config_file, dec = dec)
    x = parse_file(config_file)
    token = String( trim_padding_PKCS5(decrypt( dec, Vector{UInt8}( x["token"] ) )) )
    ["Content-Type" => "application/json", "Accept" => "application/json", "Authorization" => token]
end # function

function add_token( pat; enc = enc, config_file = config_file )
    x = parse_file(config_file)
    x["token"] = String( encrypt(enc, add_padding_PKCS5(Vector{UInt8}(pat),16) ) )
    write_file( config_file, x )
end # function
