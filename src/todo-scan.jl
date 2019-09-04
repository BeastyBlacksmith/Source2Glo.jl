# TODO: find me
struct TODO
    indicator::String
    text::String
    file::String
    line_number::UInt32
    project::String
end

function Base.show(io::IO, todo::TODO)
    println(io,
        """
        $(todo.project):
        \e[1m$(todo.indicator)\e[0m $(todo.text)
        in $(todo.file) : line $(Int(todo.line_number))
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
            # TODO: make this configurable
            filter!(f->endswith(f,".jl"), files)
            for file in files
                open( joinpath(root,file) ) do io
                    line_number = 0
                    for line in eachline(io)
                        line_number += 1
                        # TODO: add more identifiers
                        the_match = match( r"#\s*TODO(.*)", line )
                        if the_match !== nothing
                            push!( todos, TODO("TODO", the_match.captures[1], file, line_number, project) )
                        end
                    end
                end
            end
        end
    end
    return todos
end # function
