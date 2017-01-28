using Documenter

makedocs(
  doctest = false,
  format = :html,
  sitename = "JuliaSmoothOptimizers",
  assets = ["assets/style.css"],
  pages = Any["Home" => "index.md",
              "Status" => "status.md"]
)

deploydocs(deps = nothing, make = nothing,
  repo = "github.com/JuliaSmoothOptimizers/JuliaSmoothOptimizers.github.io.git",
  target = "build"
)
