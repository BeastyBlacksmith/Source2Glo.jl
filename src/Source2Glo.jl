module Source2Glo

using JSON
using Nettle
using Glo

const enc = Encryptor("AES256", hex2bytes("603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4"))
const dec = Decryptor("AES256", hex2bytes("603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4"))
const config_file = Ref("config.json")
const configuration = Dict{String,Any}()

include("configuration.jl")

function __init__()
    if (!isfile)(config_file[])
        write_file(config_file[], :paths=>String[])
    end
    parse_file(config_file)
    if !haskey(configuration, "paths")
        write_file(config_file, :paths=>String[])
    end
    if !haskey(configuration, "token")
        @info "No access token found. Please create one [here](https://app.gitkraken.com/pat/new) and insert here."
        add_token( readline(stdin) )
    end
    if !haskey(configuration, "board_id")
        board = Glo.boards("{\"name\": \".~*~. todo-Source2Glo .~*~.\"}", header = default_header())
        configuration["board_id"] = board["id"]
    end
end # function
atexit(()->write_file(config_file[], configuration))
end # module
