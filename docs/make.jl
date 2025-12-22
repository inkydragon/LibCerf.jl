using LibCerf
using Documenter

DocMeta.setdocmeta!(LibCerf, :DocTestSetup, :(using LibCerf); recursive=true)

makedocs(;
    modules=[LibCerf],
    authors="Chengyu HAN <cyhan.dev@outlook.com> and contributors",
    sitename="LibCerf.jl",
    format=Documenter.HTML(;
        canonical="https://inkydragon.github.io/LibCerf.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/inkydragon/LibCerf.jl",
    devbranch="main",
)
