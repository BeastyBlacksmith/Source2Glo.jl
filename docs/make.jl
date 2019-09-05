using Documenter, Source2Glo

makedocs(;
    modules=[Source2Glo],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/beastyblacksmith/Source2Glo.jl/blob/{commit}{path}#L{line}",
    sitename="Source2Glo.jl",
    authors="Simon Christ",
)

deploydocs(;
    repo="github.com/beastyblacksmith/Source2Glo.jl",
)
