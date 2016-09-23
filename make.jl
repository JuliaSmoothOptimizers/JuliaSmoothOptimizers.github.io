using Documenter

makedocs()

deploydocs(deps = Deps.pip("pygments", "mkdocs", "mkdocs-material", "python-markdown-math"),
  repo = "github.com/JuliaSmoothOptimizers/JuliaSmoothOptimizers.github.io.git",
  target = ".",
  julia = "release",
  latest = "site",
  branch = "master"
)
