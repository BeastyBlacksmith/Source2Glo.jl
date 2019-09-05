struct TODO
    indicator::String
    text::String
    file::String
    line_number::UInt32
    project::String
end

# TODO: define json method for it
function Base.show(io::IO, todo::TODO)
    println(io,
        """
        $(todo.project):
        in $(todo.file) : line $(Int(todo.line_number))
        \e[1m$(todo.indicator)\e[0m $(todo.text)
        """
    )
end # function

function find_todos()
    todos = TODO[]
    for project in configuration["paths"]
        for (root, dirs, files) in walkdir(project)
            if startswith(splitdir(root)[2], '.')
                continue
            end
            filter!(f->any(endswith.(f,configuration["file-endings"])), files)
            for file in files
                open( joinpath(root,file) ) do io
                    line_number = 0
                    for line in eachline(io)
                        line_number += 1
                        the_match = match( Regex("($(join(configuration["identifiers"],"|")))\\s*:\\s*(.*)"), line )
                        if the_match !== nothing
                            push!( todos, TODO(the_match.captures[1], the_match.captures[2], file, line_number, project) )
                        end
                    end
                end
            end
        end
    end
    return todos
end # function
