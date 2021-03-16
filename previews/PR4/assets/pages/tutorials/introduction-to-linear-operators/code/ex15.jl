# This file was generated, do not modify it. # hide
L = 5
m = 30
δ = 0.01
α = 0.5

U0, A = HeatEquation(u0, L, m, δ, α)
U = copy(U0)

plot_rows = 4
plot_cols = 4
plots = []

Δt = 10

for i = 1:plot_rows
  for j = 1:plot_cols
    global U

    local p = surface(reshape(U, m, m), leg=false, c=cgrad(colors), camera=(50,70))
    zlims!(0, maximum(U0))
    xticks!(Float64[])
    yticks!(Float64[])
    k = (i - 1) * plot_cols + j
    title!("t = $(round(k * Δt * δ, digits=3))")
    push!(plots, p)

    for t = 1:Δt
      U = A * U
    end
  end
end
plot(plots..., layout=(plot_rows, plot_cols), size=(1000, plot_rows * 250))
png(joinpath(@OUTPUT, "surface2")) # hide