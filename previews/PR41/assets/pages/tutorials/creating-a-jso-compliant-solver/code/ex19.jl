# This file was generated, do not modify it. # hide
function newton(
  nlp :: AbstractNLPModel; # Only mandatory argument, notice the ;
  max_time :: Float64 = 30.0, # maximum allowed time
  max_iter :: Int = 100 # maximum allowed iterations
)
  # …
  x = copy(nlp.meta.x0) # starting point # hide
  α = 1e-2 # Armijo parameter # hide
  ρ = 0.0 # hide
  iter = 0
  t₀ = time()
  Δt = time() - t₀
  status = :unknown
  tired = Δt ≥ max_time > 0 || iter ≥ max_iter > 0
  solved = norm(grad(nlp, x)) ≤ 1e-6
  while !(solved || tired)
    # …
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
    iter += 1
    Δt = time() - t₀
    tired = Δt ≥ max_time > 0 || iter ≥ max_iter > 0
    solved = norm(grad(nlp, x)) ≤ 1e-6
  end
  if solved
    status = :first_order
  elseif tired
    if Δt ≥ max_time > 0
      status = :max_time
    elseif iter ≥ max_iter > 0
      status = :max_iter
    end
  end

  return GenericExecutionStats(status, nlp, solution=x, objective=obj(nlp, x), iter=iter, elapsed_time=Δt)
end