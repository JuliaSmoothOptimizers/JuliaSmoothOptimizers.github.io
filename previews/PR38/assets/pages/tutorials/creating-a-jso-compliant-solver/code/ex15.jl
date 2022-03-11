# This file was generated, do not modify it. # hide
function newton(nlp :: AbstractNLPModel)
  # …
  x = copy(nlp.meta.x0) # starting point # hide
  α = 1e-2 # Armijo parameter # hide
  ρ = 0.0 # hide
  while norm(grad(nlp, x)) > 1e-6 # hide
    B = Symmetric(hess(nlp, x), :L) # hide
    factor = cholesky(B + ρ * I, check=false) # hide
    while !issuccess(factor) # hide
      ρ = max(1e-8, 10ρ) # hide
      factor = cholesky(B + ρ * I, check=false) # hide
    end # hide
    d = factor \ -grad(nlp, x) # hide
    t = 1.0 # hide
    fx = obj(nlp, x) # hide
    ft = obj(nlp, x + t * d) # hide
    slope = dot(grad(nlp, x), d) # hide
    while !(ft ≤ fx + α * t * slope) # hide
      t *= 0.5 # hide
      ft = obj(nlp, x + t * d) # hide
    end # hide
    x += t * d # hide
  end # hide
  status = :first_order # hide

  return GenericExecutionStats(status, nlp, solution=x, objective=obj(nlp, x))
end