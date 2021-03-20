# This file was generated, do not modify it. # hide
function HeatEquationOp(L, m, δ, α)
  h = L / (m - 1)
  γ = α * δ / h^2
  κ = 1 - 4γ

  Tprod(v) = [κ * v[1] + 2γ * v[2];
             [γ * v[i-1] + κ * v[i] + γ * v[i+1] for i = 2:m-1];
              κ * v[m] + 2γ * v[m-1]]

  T = LinearOperator(Float64, m, m, false, false, Tprod)
  D = opEye(m) * γ

  function prod(v)
    Hv = zeros(m^2)
    Hv[1:m] .= [T  2D] * v[1:2m]
    for i = 2:m-1
      Hv[(i-1)*m+1:i*m] .= [D T D] * v[(i-2)*m+1:(i+1)*m]
    end
    Hv[end-m+1:end] .= [2D T] * v[end-2m+1:end]
    return Hv
  end

  return LinearOperator(Float64, m^2, m^2, false, false, prod)
end