# This file was generated, do not modify it. # hide
function HeatEquation(u0, L, m, δ, α)
  h = L / (m - 1)
  U = zeros(m^2)
  for i = 1:m
    x = (i - 1) * h
    for j = 1:m
      y = (j - 1) * h
      U[(i - 1)*m + j] = u0(x, y)
    end
  end
  A = HeatEquationOp(L, m, δ, α)

  return U, A
end