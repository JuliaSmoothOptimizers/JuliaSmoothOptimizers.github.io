@def title = "How to create a model from the function and its derivatives"
@def showall = true
@def tags = ["models", "manual"]

\preamble{Abel S. Siqueira}


![JSON 0.21.4](https://img.shields.io/badge/JSON-0.21.4-000?style=flat-square&labelColor=999)
[![NLPModels 0.20.0](https://img.shields.io/badge/NLPModels-0.20.0-8b0000?style=flat-square&labelColor=cb3c33)](https://juliasmoothoptimizers.github.io/NLPModels.jl/stable/)
[![ManualNLPModels 0.1.5](https://img.shields.io/badge/ManualNLPModels-0.1.5-8b0000?style=flat-square&labelColor=cb3c33)](https://juliasmoothoptimizers.github.io/ManualNLPModels.jl/stable/)
[![NLPModelsJuMP 0.12.1](https://img.shields.io/badge/NLPModelsJuMP-0.12.1-8b0000?style=flat-square&labelColor=cb3c33)](https://juliasmoothoptimizers.github.io/NLPModelsJuMP.jl/stable/)
![BenchmarkTools 1.3.2](https://img.shields.io/badge/BenchmarkTools-1.3.2-000?style=flat-square&labelColor=999)
[![ADNLPModels 0.6.2](https://img.shields.io/badge/ADNLPModels-0.6.2-8b0000?style=flat-square&labelColor=cb3c33)](https://juliasmoothoptimizers.github.io/ADNLPModels.jl/stable/)
![JuMP 1.12.0](https://img.shields.io/badge/JuMP-1.12.0-000?style=flat-square&labelColor=999)
[![JSOSolvers 0.11.0](https://img.shields.io/badge/JSOSolvers-0.11.0-006400?style=flat-square&labelColor=389826)](https://juliasmoothoptimizers.github.io/JSOSolvers.jl/stable/)



When you know the derivatives of your optimization problem, it is frequently more efficient to use them directly instead of relying on automatic differentiation.
For that purpose, we have created `ManualNLPModels`. The package is very crude, due to demand being low, but let us know if you need more functionalities.

For instance, in the logistic regression problem, we have a model
$h_{\beta}(x) = \sigma(\hat{x}^T \beta) = \sigma(\beta_0 + x^T\beta_{1:p})$,
where
$\hat{x} = \begin{bmatrix} 1 \\ x \end{bmatrix}$.
The value of $\beta$ is found by finding the minimum of the negavitve of the log-likelihood function.

$$\ell(\beta) = -\frac{1}{n} \sum_{i=1}^n y_i \ln \big(h_{\beta}(x_i)\big) + (1 - y_i) \ln\big(1 - h_{\beta}(x_i)\big).$$

We'll input the gradient of this function manually. It is given by

$$\nabla \ell(\beta) = \frac{-1}{n} \sum_{i=1}^n \big(y_i - h_{\beta}(x_i)\big) \hat{x}_i = \frac{1}{n} \begin{bmatrix} e^T \\ X^T \end{bmatrix} (h_{\beta}(X) - y),$$

where $e$ is the vector with all components equal to 1.

```julia
using ManualNLPModels
using LinearAlgebra, Random
Random.seed!(0)

sigmoid(t) = 1 / (1 + exp(-t))
h(β, X) = sigmoid.(β[1] .+ X * β[2:end])

n, p = 500, 50
X = randn(n, p)
β = randn(p + 1)
y = round.(h(β, X) .+ randn(n) * 0.1)

function myfun(β, X, y)
  @views hβ = sigmoid.(β[1] .+ X * β[2:end])
  out = sum(
    yᵢ * log(ŷᵢ + 1e-8) + (1 - yᵢ) * log(1 - ŷᵢ + 1e-8)
    for (yᵢ, ŷᵢ) in zip(y, hβ)
  )
  return -out / n + 0.5e-4 * norm(β)^2
end

function mygrad(out, β, X, y)
  n = length(y)
  @views δ = (sigmoid.(β[1] .+ X * β[2:end]) - y) / n
  out[1] = sum(δ) + 1e-4β[1]
  @views out[2:end] .= X' * δ + 1e-4 * β[2:end]
  return out
end

nlp = NLPModel(
  zeros(p + 1),
  β -> myfun(β, X, y),
  grad=(out, β) -> mygrad(out, β, X, y),
)
```

```plaintext
ManualNLPModels.NLPModel{Float64, Vector{Float64}}
  Problem name: Generic
   All variables: ████████████████████ 51     All constraints: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            free: ████████████████████ 51                free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0              low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
          infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: (100.00% sparsity)   0               linear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                    nonlinear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                         nnzj: (------% sparsity)         

  Counters:
             obj: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 grad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 cons: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
        cons_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0             cons_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 jcon: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           jgrad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                  jac: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0              jac_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         jac_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                jprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0            jprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
       jprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               jtprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0           jtprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
      jtprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 hess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                hprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           jhess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               jhprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0
```





Notice that the `grad` function must modify the first argument so you don't waste memory creating arrays.

Only the `obj`, `grad` and `grad!` functions will be defined for this model, so you need to choose your solver carefully.
We'll use `lbfgs` from `JSOSolvers.jl`.

```julia
using JSOSolvers

output = lbfgs(nlp)
βsol = output.solution
ŷ = round.(h(βsol, X))
sum(ŷ .== y) / n
```

```plaintext
1.0
```





We can compare against other approaches.

```julia
using BenchmarkTools
using Logging

@benchmark begin
  nlp = NLPModel(
    zeros(p + 1),
    β -> myfun(β, X, y),
    grad=(out, β) -> mygrad(out, β, X, y),
  )
  output = with_logger(NullLogger()) do
    lbfgs(nlp)
  end
end
```

```plaintext
BenchmarkTools.Trial: 1844 samples with 1 evaluation.
 Range (min … max):  2.374 ms …   7.601 ms  ┊ GC (min … max): 0.00% … 58.28%
 Time  (median):     2.519 ms               ┊ GC (median):    0.00%
 Time  (mean ± σ):   2.706 ms ± 876.791 μs  ┊ GC (mean ± σ):  5.78% ± 11.17%

  █▇▇▆▄▂                                                       
  ██████▇▆▅▄▄▄▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▄▇▇▇██ █
  2.37 ms      Histogram: log(frequency) by time      7.21 ms <

 Memory estimate: 1.73 MiB, allocs estimate: 2655.
```



```julia
using ADNLPModels

@benchmark begin
  adnlp = ADNLPModel(β -> myfun(β, X, y), zeros(p + 1))
  output = with_logger(NullLogger()) do
    lbfgs(adnlp)
  end
end
```

```plaintext
BenchmarkTools.Trial: 3 samples with 1 evaluation.
 Range (min … max):  1.647 s …   1.730 s  ┊ GC (min … max): 12.81% … 14.83%
 Time  (median):     1.707 s              ┊ GC (median):    15.03%
 Time  (mean ± σ):   1.695 s ± 42.971 ms  ┊ GC (mean ± σ):  14.34% ±  1.32%

  █                                        █              █  
  █▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁█▁▁▁▁▁▁▁▁▁▁▁▁▁▁█ ▁
  1.65 s         Histogram: frequency by time        1.73 s <

 Memory estimate: 448.57 MiB, allocs estimate: 6426996.
```



```julia
using JuMP
using NLPModelsJuMP

@benchmark begin
  model = Model()
  @variable(model, modelβ[1:p+1])
  @NLexpression(model,
    xᵀβ[i=1:n],
    modelβ[1] + sum(modelβ[j + 1] * X[i,j] for j = 1:p)
  )
  @NLexpression(
    model,
    hβ[i=1:n],
    1 / (1 + exp(-xᵀβ[i]))
  )
  @NLobjective(model, Min,
    -sum(y[i] * log(hβ[i] + 1e-8) + (1 - y[i] * log(hβ[i] + 1e-8)) for i = 1:n) / n + 0.5e-4 * sum(modelβ[i]^2 for i = 1:p+1)
  )
  jumpnlp = MathOptNLPModel(model)
  output = with_logger(NullLogger()) do
    lbfgs(jumpnlp)
  end
end
```

```plaintext
BenchmarkTools.Trial: 32 samples with 1 evaluation.
 Range (min … max):  151.953 ms … 172.083 ms  ┊ GC (min … max): 7.88% … 11.86%
 Time  (median):     157.138 ms               ┊ GC (median):    7.65%
 Time  (mean ± σ):   160.681 ms ±   6.355 ms  ┊ GC (mean ± σ):  8.22% ±  1.69%

              ▁█▁               ▁                                
  ▆▁▆▁▆▆▆▆▁▁▁▆███▆▆▁▁▁▁▁▁▁▁▆▁▁▁▁█▁▁▆▁▁▁▁▆▁▆▁▆▁▆▆▁▁▆▁▁▆▁▁▁▁▆▁▆▆▆ ▁
  152 ms           Histogram: frequency by time          172 ms <

 Memory estimate: 98.01 MiB, allocs estimate: 436900.
```





Or just the grad calls:

```julia
using NLPModels

@benchmark grad(nlp, β)
```

```plaintext
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  12.300 μs …  7.114 ms  ┊ GC (min … max): 0.00% … 88.44%
 Time  (median):     14.501 μs              ┊ GC (median):    0.00%
 Time  (mean ± σ):   16.550 μs ± 95.792 μs  ┊ GC (mean ± σ):  7.58% ±  1.33%

      ▆▄▄▆▄█▂▁▁▄                                               
  ▃▅▇███████████▇▇▆▆▇▅▅▅▅▄▃▃▃▃▃▃▃▃▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▁▂▂ ▄
  12.3 μs         Histogram: frequency by time        25.4 μs <

 Memory estimate: 18.19 KiB, allocs estimate: 8.
```



```julia
adnlp = ADNLPModel(β -> myfun(β, X, y), zeros(p + 1))
@benchmark grad(adnlp, β)
```

```plaintext
BenchmarkTools.Trial: 1156 samples with 1 evaluation.
 Range (min … max):  4.262 ms …   9.244 ms  ┊ GC (min … max): 0.00% … 50.32%
 Time  (median):     4.284 ms               ┊ GC (median):    0.00%
 Time  (mean ± σ):   4.323 ms ± 357.070 μs  ┊ GC (mean ± σ):  0.60% ±  3.75%

     ▅██▅▂                                                     
  ▃▄██████▇▅▄▃▃▂▂▁▂▂▂▁▁▁▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▂▁▁▁▁▁▁▁▂▂▂▂▃▃▂▂ ▃
  4.26 ms         Histogram: frequency by time        4.49 ms <

 Memory estimate: 471.91 KiB, allocs estimate: 42.
```



```julia
model = Model()
@variable(model, modelβ[1:p+1])
@NLexpression(model,
  xᵀβ[i=1:n],
  modelβ[1] + sum(modelβ[j + 1] * X[i,j] for j = 1:p)
)
@NLexpression(
  model,
  hβ[i=1:n],
  1 / (1 + exp(-xᵀβ[i]))
)
@NLobjective(model, Min,
  -sum(y[i] * log(hβ[i] + 1e-8) + (1 - y[i] * log(hβ[i] + 1e-8)) for i = 1:n) / n + 0.5e-4 * sum(modelβ[i]^2 for i = 1:p+1)
)
jumpnlp = MathOptNLPModel(model)
@benchmark grad(jumpnlp, β)
```

```plaintext
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  225.605 μs … 821.420 μs  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     232.406 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   233.738 μs ±   9.509 μs  ┊ GC (mean ± σ):  0.00% ± 0.00%

              ▁██▃                                               
  ▁▂▄▇▆▆▄▃▁▂▂▆████▆▄▃▃▂▂▂▂▂▂▂▃▂▃▂▂▂▂▁▁▁▂▂▁▁▁▁▁▁▁▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁ ▂
  226 μs           Histogram: frequency by time          255 μs <

 Memory estimate: 496 bytes, allocs estimate: 1.
```





Take these benchmarks with a grain of salt. They are being run on a github actions server with global variables.
If you want to make an informed option, you should consider performing your own benchmarks.

