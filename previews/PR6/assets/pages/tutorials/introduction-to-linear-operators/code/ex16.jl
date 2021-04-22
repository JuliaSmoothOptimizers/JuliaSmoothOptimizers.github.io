# This file was generated, do not modify it. # hide
U0, A = HeatEquation(u0, L, m, δ, α)
U = copy(U0)

Δt = 2.5

anim = Animation()
for i = 1:60
  global U

  rU = reshape(U, m, m)
  local p = plot(; leg=false, size=(1000,500), layout=@layout [a b])
  surface!(p[1], rU, c=cgrad(colors), camera=(50,70))
  contour!(p[2], rU, levels=range(0.1, maximum(U0), length=50), c=cgrad(colors))
  zlims!(0, maximum(U0))
  frame(anim)

  for t = 1:Δt
    U = A * U
  end
end