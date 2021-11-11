# This file was generated, do not modify it. # hide
open("newton.tex", "w") do io
  pretty_latex_stats(io, stats[:newton][!, cols])
end
rm("newton.tex") # hide