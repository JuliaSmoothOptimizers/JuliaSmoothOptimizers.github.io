# This file was generated, do not modify it. # hide
function newton2(
  nlp :: AbstractNLPModel; # Only mandatory argument
  x :: AbstractVector = copy(nlp.meta.x0), # optimal starting point
  atol :: Real = 1e-6, # absolute tolerance
  rtol :: Real = 1e-6, # relative tolerance
  max_time :: Float64 = 30.0, # maximum allowed time
  max_iter :: Int = 100 # maximum allowed iterations
)

  # Initialization
  fx = obj(nlp, x)
  ∇fx = grad(nlp, x)

  iter = 0
  Δt = 0.0
  t₀ = time()
  α = 1e-2
  ρ = 0.0
  status = :unknown
  ϵ = atol + rtol * norm(∇fx)

  tired = Δt ≥ max_time > 0 || iter ≥ max_iter > 0
  optimal = norm(∇fx) < ϵ

  while !(optimal || tired) # while not optimal or tired

    B = Symmetric(hess(nlp, x), :L)
    factor = cholesky(B + ρ * I, check=false)
    while !issuccess(factor)
      ρ = max(1e-8, 10ρ)
      factor = cholesky(B + ρ * I, check=false)
    end
    d = factor \ -grad(nlp, x)
    ρ = ρ / 10

    t = 1.0
    ft = obj(nlp, x + t * d)
    slope = dot(grad(nlp, x), d)
    while !(ft ≤ fx + α * t * slope)
      t *= 0.5
      ft = obj(nlp, x + t * d)
    end
    t

    x += t * d

    fx = obj(nlp, x)
    ∇fx = grad(nlp, x)

    iter += 1
    Δt = time() - t₀
    tired = Δt ≥ max_time > 0 || iter ≥ max_iter > 0
    ϵ = atol + rtol * norm(∇fx)
    optimal = norm(∇fx) < ϵ
  end

  if optimal
    status = :first_order
  elseif tired
    if iter ≥ max_iter > 0
      status = :max_iter
    elseif Δt ≥ max_time > 0
      status = :max_time
    end
  end

  return GenericExecutionStats(status, nlp, solution=x, objective=fx, dual_feas=norm(∇fx), iter=iter, elapsed_time=Δt)

end