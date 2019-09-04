function update_board(;header = default_header())
    board_id = Glo.BoardID( configuration["board_id"] )
    cards = Glo.boards_cards( board_id, header = header )
    columns = Glo.boards_columns( board_id, header = header )
    todos = find_todos()
    # TODO: sort todos by project?
    for todo in todos
        card_ind = findfirst(c->c["name"] == todo.text, cards)
        card = cards[card_ind]
        deleteat!(cards, card_ind)
        if card === nothing
            column_ind = findfirst(c->c["name"] == todo.project, columns)
            column = columns[column_ind]
            deleteat!(columns, column_ind)
            if column === nothing
                column = Glo.boards_columns(Dict("name"=>todo.project), board_id, header = header )
            end
            Glo.boards_cards(Dict(
                "name"=>todo.text,
                "column_id"=>column["id"],
                "description"=>repr(todo)
                ), board_id, header = header)
        else
            if card["description"] != repr(todo)
                card["description"] = repr(todo)
            end
            Glo.boards_cards(card, board_id, card["id"], header = header)
        end
    end
    for card in cards
        Glo.boards_cards(!,board_id,card["id"], header = header)
    end
    for column in columns
        Glo.boards_columns(!,board_id,column["id"], header = header)
    end
    return nothing
end # function
