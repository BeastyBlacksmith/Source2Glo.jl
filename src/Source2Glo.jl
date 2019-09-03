module Source2Glo

using JSON
using Nettle
using Glo

const enc = Encryptor("AES256", hex2bytes("603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4"))
const dec = Decryptor("AES256", hex2bytes("603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4"))
const config_file = Ref(joinpath(@__DIR__,"../config.json"))
const configuration = Dict{String,Any}()

include("configuration.jl")
# TODO: ↓
# include("todo-scan.jl")
# include("board-managment.jl")

function __init__()
    if !isfile(config_file[])
        write_file(config_file[], :paths=>String[])
    end
    parse_file(config_file[])
    if !haskey(configuration, "paths")
        configuration["paths"] = String[]
    end
    if !haskey(configuration, "token")
        @info "No access token found. Please create one [here](https://app.gitkraken.com/pat/new) and insert below."
        add_token( readline(stdin), enc = enc )
        #TODO: user creates key here (where to store that?)
    end
    if !haskey(configuration, "board_id")
        board = Glo.boards("{\"name\": \".~*~. todo-Source2Glo .~*~.\"}", header = default_header())
        configuration["board_id"] = board["id"]
    end
end # function
# atexit(()->write_file(config_file[], configuration))
end # module
