module Source2Glo

using JSON
using Nettle

const enc = Encryptor("AES256", hex2bytes("603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4"))
const dec = Decryptor("AES256", hex2bytes("603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4"))
const config_file = joinpath(@__DIR__,"../config.json")

include("configuration.jl")

function __init__()
    if (!isfile)(config_file)
        write_file(config_file, :paths=>String[])
    else
        x = parse_file(config_file)
        @show x
        if haskey(x, "paths")
            return
        end
        write_file(config_file, :paths=>String[])
    end
end # function
end # module
