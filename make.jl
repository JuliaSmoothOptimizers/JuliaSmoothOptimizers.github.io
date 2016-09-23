using Documenter

makedocs()

deploydocs(deps = Deps.pip("pygments", "mkdocs", "mkdocs-material", "python-markdown-math"),
  repo = "github.com/JuliaSmoothOptimizers/NLPModels.jl.git",
  julia = "release",
  latest = "site",
  branch = "master"
)
