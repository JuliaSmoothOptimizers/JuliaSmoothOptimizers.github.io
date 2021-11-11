# This file was generated, do not modify it.

using Plots
gr(size=(600,300))
contour(-2:0.02:2, -0.5:0.02:1.5, (x,y) -> (x - 1)^2 + 4 * (y - x^2)^2, levels=(0:0.2:10).^2)
png(joinpath(@OUTPUT, "prob1")) # hide

using ADNLPModels

nlp = ADNLPModel(
  x -> (x[1] - 1)^2 + 4 * (x[2] - x[1]^2)^2, # function
  [-1.2; 1.0] # starting point
)

(
  nlp.meta.nvar, # number of variable
  nlp.meta.ncon, # number of constraints
  nlp.meta.lvar, nlp.meta.uvar, # bounds on variables
  nlp.meta.lcon, nlp.meta.ucon, # bounds on constraints
  nlp.meta.x0 # starting point
)

using NLPModels

unconstrained(nlp)

x = nlp.meta.x0
obj(nlp, x)

grad(nlp, x)

hess(nlp, x)

using LinearAlgebra

Symmetric(hess(nlp, x), :L)

B = Symmetric(hess(nlp, x), :L)
factor = cholesky(B, check=false) # check is false to prevent an error from being thrown.
issuccess(factor)

B = -Symmetric(hess(nlp, x), :L) # Since the last one is positive definite, this one shouldn't be
factor = cholesky(B, check=false)
issuccess(factor)

ρ = 0.0 # First iteration

B = Symmetric(hess(nlp, x), :L)
factor = cholesky(B + ρ * I, check=false)
while !issuccess(factor)
  ρ = max(1e-8, 10ρ)
  factor = cholesky(B + ρ * I, check=false)
end
d = factor \ -grad(nlp, x)

α = 1e-2
t = 1.0
fx = obj(nlp, x)
ft = obj(nlp, x + t * d)
slope = dot(grad(nlp, x), d)
while !(ft ≤ fx + t * slope)
  global t *= 0.5 # global is used because we are outside a function
  ft = obj(nlp, x + t * d)
end

using SolverCore

function newton(nlp :: AbstractNLPModel)

  x = copy(nlp.meta.x0) # starting point
  α = 1e-2 # Armijo parameter
  ρ = 0.0

  while norm(grad(nlp, x)) > 1e-6

    # Computing the direction
    B = Symmetric(hess(nlp, x), :L)
    factor = cholesky(B + ρ * I, check=false)
    while !issuccess(factor)
      ρ = max(1e-8, 10ρ)
      factor = cholesky(B + ρ * I, check=false)
    end
    d = factor \ -grad(nlp, x)

    # Computing the step length
    t = 1.0
    fx = obj(nlp, x)
    ft = obj(nlp, x + t * d)
    slope = dot(grad(nlp, x), d)
    while !(ft ≤ fx + α * t * slope)
      t *= 0.5
      ft = obj(nlp, x + t * d)
    end

    x += t * d
  end

  status = :first_order

  return GenericExecutionStats(status, nlp)

end

output = newton(nlp)

println(output)

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

output = newton(nlp)

println(output)

output.solution

SolverCore.show_statuses()

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

using JSOSolvers

output = lbfgs(nlp)
print(output)

problems = [
  ADNLPModel(x -> x[1]^2 + 4 * x[2]^2, ones(2)),
  ADNLPModel(x -> (1 - x[1])^2 + 100 * (x[2] - x[1]^2)^2, [-1.2; 1.0]),
  ADNLPModel(x -> x[1]^2 + x[2] - 11 + (x[1] + x[2]^2 - 7)^2, [-1.0; 1.0]),
  ADNLPModel(x -> log(exp(-x[1] - 2x[2]) + exp(x[1] + 2) + exp(2x[2] - 1)), zeros(2))
];

using SolverBenchmark

solvers = Dict(:newton => newton, :lbfgs => lbfgs)
stats = bmark_solvers(solvers, problems)

@show typeof(stats)
@show keys(stats)

cols = [:name, :status, :objective, :elapsed_time, :iter]
pretty_stats(stats[:newton][!, cols])

open("newton.tex", "w") do io
  pretty_latex_stats(io, stats[:newton][!, cols])
end
rm("newton.tex") # hide

using Plots
performance_profile(stats, df -> df.elapsed_time)
png(joinpath(@OUTPUT, "perfprof")) # hide

cost(df) = (df.status .!= :first_order) * Inf + df.elapsed_time
performance_profile(stats, cost)
png(joinpath(@OUTPUT, "perfprof2")) # hide

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

solvers = Dict(:newton => newton2, :lbfgs => lbfgs)
stats = bmark_solvers(solvers, problems)
cost(df) = (df.status .!= :first_order) * Inf + df.elapsed_time
performance_profile(stats, cost)
png(joinpath(@OUTPUT, "perfprof3")) # hide

