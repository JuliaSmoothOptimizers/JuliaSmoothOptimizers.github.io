# This file was generated, do not modify it. # hide
const dark_purple = Colors.RGB(0.584, 0.345, 0.698)
const dark_red    = Colors.RGB(0.796, 0.235, 0.200)
const dark_green  = Colors.RGB(0.220, 0.596, 0.149)
const black       = Colors.RGB(0.0, 0.0, 0.0)
colors = [black, dark_green, dark_green, dark_red, dark_red, dark_purple, dark_purple]

L = 5
u0(x, y) = begin
  d = [(x,y) -> ((x - sin(2π/3*i))^2 + (y - cos(2π/3*i))^2)^2 for i = 1:3]
  xx, yy = x - L / 2, y - L / 2
  return 3*exp(-sqrt(2)*d[1](xx,yy)) + 2*exp(-d[2](xx,yy)) + exp(-4*d[3](xx,yy))
end

grid = range(0, L, length=50)
maxu = maximum([u0(xi,yi) for xi in grid, yi in grid])
p = plot(; leg=false, size=(1000,500), layout=@layout [a b])
surface!(p[1], grid, grid, u0, c=cgrad(colors), camera=(50,70))
contour!(p[2], grid, grid, u0, levels=range(0.1, maxu, length=50), c=cgrad(colors))
png(p, joinpath(@OUTPUT, "surface1")) # hide