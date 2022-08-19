@def title = "CaNNOLeS.jl tutorial"
@def showall = true
@def tags = ["solvers", "cannoles"]

\preamble{Abel S. Siqueira}



CaNNOLeS is a solver for equality-constrained nonlinear least-squares problems, i.e.,
optimization problems of the form

    min ¹/₂‖F(x)‖²      s. to     c(x) = 0.

It uses other JuliaSmoothOptimizers packages for development.
In particular, [NLPModels.jl](https://github.com/JuliaSmoothOptimizers/NLPModels.jl) is used for defining the problem, and [SolverCore](https://github.com/JuliaSmoothOptimizers/SolverCore.jl) for the output.
It also uses [HSL.jl](https://github.com/JuliaSmoothOptimizers/HSL.jl)'s `MA57` as main solver, but you can pass `linsolve=:ldlfactorizations` to use [LDLFactorizations.jl](https://github.com/JuliaSmoothOptimizers/LDLFactorizations.jl).

## Fine-tune CaNNOLeS

CaNNOLeS.jl exports the function `cannoles`:
```plaintext
   cannoles(nlp :: AbstractNLPModel; kwargs...)
```

Find below a list of the main options of `cannoles`.

### Tolerances on the problem

```plaintext
| Parameters           | Type          | Default         | Description                                        |
| -------------------- | ------------- | --------------- | -------------------------------------------------- |
| ϵtol                 | AbstractFloat | √eps(eltype(x)) | tolerance.                                         |
| unbounded_threshold  | AbstractFloat | -1e5            | below this threshold the problem is unbounded.     |
| max_f                | Integer       | 100000          | evaluation limit, e.g. `sum_counters(nls) > max_f` |
| max_time             | AbstractFloat | 30.             | maximum number of seconds.                         |
| max_inner            | Integer       | 10000           | maximum number of iterations.                      |
```

### Algorithmic parameters

```plaintext
| Parameters                  | Type           | Default           | Description                                        |
| --------------------------- | -------------- | ----------------- | -------------------------------------------------- |
| x                           | AbstractVector | copy(nls.meta.x0) | initial guess. |
| λ                           | AbstractVector | eltype(x)[]       | initial guess for the Lagrange mutlipliers. |
| method                      | Symbol         | :Newton           | method to compute direction, `:Newton`, `:LM`, `:Newton_noFHess`, or `:Newton_vanishing`. |
| merit                       | Symbol         | :auglag           | merit function: `:norm1`, `:auglag` |
| linsolve                    | Symbol         | :ma57             | solver use to compute the factorization: `:ma57`, `:ma97`, `:ldlfactorizations` |
| check_small_residual        | Bool           | true              | |
| always_accept_extrapolation | Bool           | false             | |
| δdec                        | Real           | eltype(x)(0.1)    | |
```

## Examples

```julia
using CaNNOLeS, ADNLPModels

# Rosenbrock
nls = ADNLSModel(x -> [x[1] - 1; 10 * (x[2] - x[1]^2)], [-1.2; 1.0], 2)
stats = cannoles(nls, ϵtol = 1e-5, x = ones(2))
```

```plaintext
"Execution stats: first-order stationary"
```



```julia
# Constrained
nls = ADNLSModel(
  x -> [x[1] - 1; 10 * (x[2] - x[1]^2)],
  [-1.2; 1.0],
  2,
  x -> [x[1] * x[2] - 1],
  [0.0],
  [0.0],
)
stats = cannoles(nls, max_time = 10., merit = :auglag)
```

```plaintext
"Execution stats: first-order stationary"
```


