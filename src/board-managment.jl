function update_board(;key = key[])
    token = String( trim_padding_PKCS5(decrypt( Decryptor("AES256", key), Vector{UInt8}( configuration["token"] ) )) )
    header = ["Content-Type" => "application/json", "Accept" => "application/json", "Authorization" => token]
    board_id = Glo.BoardID( configuration["board_id"] )
    cards = Glo.boards_cards( board_id, header = header )
    columns = get(Glo.boards( board_id, header = header ),"columns",Dict{String,Any}[])
    todos = find_todos()
    # TODO: sort todos by project?
    for todo in todos
        project = last( splitpath(todo.project) )
        card_ind = findfirst(c->c["name"] == todo.text, cards)
        if card_ind === nothing
            column_ind = findfirst(c->c["name"] == project, columns)
            if column_ind === nothing
                column = Glo.boards_columns(Dict("name"=>project), board_id, header = header )
                push!( columns, column )
            else
                column = columns[column_ind]
            end
            Glo.boards_cards(Dict(
                "name"=>todo.text,
                "column_id"=>column["id"],
                "description"=>("text" => repr(todo))
                ), board_id, header = header)
        else
            card = cards[card_ind]
            deleteat!(cards, card_ind)
            if get(card,"description",Dict("text"=>""))["text"] != repr(todo)
                card["description"] = "text" => repr(todo)
            end
            Glo.boards_cards(card, board_id, Glo.CardID(card["id"]), header = header)
        end
    end
    for card in cards
        Glo.boards_cards(!,board_id,Glo.CardID(card["id"]), header = header)
    end
    # TODO: detect untouched columns
    # for column in columns
    #     Glo.boards_columns(!,board_id,column["id"], header = header)
    # end
    return nothing
end # function
