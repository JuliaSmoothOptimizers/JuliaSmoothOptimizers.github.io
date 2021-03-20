# This file was generated, do not modify it. # hide
using Plots
gr(size=(600,300))
contour(-2:0.02:2, -0.5:0.02:1.5, (x,y) -> (x - 1)^2 + 4 * (y - x^2)^2, levels=(0:0.2:10).^2)
png(joinpath(@OUTPUT, "prob1")) # hide