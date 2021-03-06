module Source2Glo

using JSON
using Glo
using Nettle

export Glo

const key = Ref(hex2bytes("603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4"))
const config_file = Ref(joinpath(homedir(),".julia/config/Source2Glo/config.json"))
const configuration = Dict{String,Any}()

include("configuration.jl")
include("todo-scan.jl")
include("board-managment.jl")

function __init__()
    # TODO: improve this
    # @info "Enter your password. (This will become your password if this is your first visit.)"
    # key[] = Vector{UInt8}(readline(stdin))
    if !isfile(config_file[])
        mkpath(dirname(config_file[]))
        write_file(config_file[], :paths=>String[])
    end
    parse_file(config_file[])
    if !haskey(configuration, "paths")
        configuration["paths"] = String[]
    end
    if !haskey(configuration, "update-mode")
        configuration["update-mode"] = "manual"
    end
    if !haskey(configuration, "file-endings")
        configuration["file-endings"] = [".jl",".txt",".md",".tex",".h",".c",".cpp"]
    end
    if !haskey(configuration, "identifiers")
        configuration["identifiers"] = ["TODO","FIXME","todo\""]
    end
    if !haskey(configuration, "token")
        @info "No access token found. Please create one [here](https://app.gitkraken.com/pat/new) and insert below."
        add_token( readline(stdin), key = key[] )
    end
    if !haskey(configuration, "board_id")
        board = Glo.boards(:name => ".~*~. todo-Source2Glo .~*~.", header = ["Content-Type" => "application/json", "Accept" => "application/json", "Authorization" => String( trim_padding_PKCS5(decrypt( Decryptor("AES256", key[]), Vector{UInt8}( configuration["token"] ) )) )])
        configuration["board_id"] = board["id"]
    end
    atexit(()->write_file(config_file[], configuration))
    if configuration["update-mode"] == "at-exit"
        atexit(()->update_board())
    elseif configuration["update-mode"] == "at-start"
        @async update_board()
    end
end # function
end # module
