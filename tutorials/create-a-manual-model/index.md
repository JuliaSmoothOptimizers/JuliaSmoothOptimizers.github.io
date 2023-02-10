@def title = "How to create a model from the function and its derivatives"
@def showall = true
@def tags = ["models", "manual"]

\preamble{Abel S. Siqueira}


![JSON 0.21.3](https://img.shields.io/badge/JSON-0.21.3-000?style=flat-square&labelColor=fff")
[![NLPModels 0.19.2](https://img.shields.io/badge/NLPModels-0.19.2-8b0000?style=flat-square&labelColor=cb3c33")](https://juliasmoothoptimizers.github.io/NLPModels.jl/stable/)
[![ManualNLPModels 0.1.3](https://img.shields.io/badge/ManualNLPModels-0.1.3-8b0000?style=flat-square&labelColor=cb3c33")](https://juliasmoothoptimizers.github.io/ManualNLPModels.jl/stable/)
[![NLPModelsJuMP 0.12.0](https://img.shields.io/badge/NLPModelsJuMP-0.12.0-8b0000?style=flat-square&labelColor=cb3c33")](https://juliasmoothoptimizers.github.io/NLPModelsJuMP.jl/stable/)
![BenchmarkTools 1.3.2](https://img.shields.io/badge/BenchmarkTools-1.3.2-000?style=flat-square&labelColor=fff")
[![ADNLPModels 0.5.1](https://img.shields.io/badge/ADNLPModels-0.5.1-8b0000?style=flat-square&labelColor=cb3c33")](https://juliasmoothoptimizers.github.io/ADNLPModels.jl/stable/)
![JuMP 1.7.0](https://img.shields.io/badge/JuMP-1.7.0-000?style=flat-square&labelColor=fff")
[![JSOSolvers 0.9.4](https://img.shields.io/badge/JSOSolvers-0.9.4-006400?style=flat-square&labelColor=389826")](https://juliasmoothoptimizers.github.io/JSOSolvers.jl/stable/)



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
BenchmarkTools.Trial: 1995 samples with 1 evaluation.
 Range (min … max):  2.340 ms …   5.557 ms  ┊ GC (min … max): 0.00% … 43.12%
 Time  (median):     2.375 ms               ┊ GC (median):    0.00%
 Time  (mean ± σ):   2.503 ms ± 450.278 μs  ┊ GC (mean ± σ):  2.81% ±  8.06%

  █▆▂             ▁▁                                           
  ████▆▅▅▄▃▅▁▁▅▃▃▄████▅▃▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▃▅▄▁▅▃▆▅▃▄▄▁▆▆▄▄▆ █
  2.34 ms      Histogram: log(frequency) by time      4.88 ms <

 Memory estimate: 1.72 MiB, allocs estimate: 2594.
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
BenchmarkTools.Trial: 54 samples with 1 evaluation.
 Range (min … max):  91.259 ms … 105.249 ms  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     91.858 ms               ┊ GC (median):    0.00%
 Time  (mean ± σ):   93.823 ms ±   3.564 ms  ┊ GC (mean ± σ):  1.04% ± 1.59%

   ██           ▃                                               
  ▇██▆▁▁▁▃▁▁▁▁▁▁██▄▁▁▁▁▁▁▁▁▃▁▁▁▁▁▁▁▁▃▁▁▁▁▁▁▃▁▁▁▁▁▁▁▁▁▁▁▁▁▁▃▁▃▃ ▁
  91.3 ms         Histogram: frequency by time          104 ms <

 Memory estimate: 30.79 MiB, allocs estimate: 10075.
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
BenchmarkTools.Trial: 35 samples with 1 evaluation.
 Range (min … max):  129.944 ms … 155.945 ms  ┊ GC (min … max): 0.00% … 6.57%
 Time  (median):     142.036 ms               ┊ GC (median):    6.99%
 Time  (mean ± σ):   143.817 ms ±   7.902 ms  ┊ GC (mean ± σ):  4.82% ± 3.70%

  ▁ ██         ▁  ▁▁    ▁▁█ ███▁    █ ▁    ▁▁ ▁    ▁▁  █ ▁█  ▁█  
  █▁██▁▁▁▁▁▁▁▁▁█▁▁██▁▁▁▁███▁████▁▁▁▁█▁█▁▁▁▁██▁█▁▁▁▁██▁▁█▁██▁▁██ ▁
  130 ms           Histogram: frequency by time          156 ms <

 Memory estimate: 98.00 MiB, allocs estimate: 436895.
```





Or just the grad calls:

```julia
using NLPModels

@benchmark grad(nlp, β)
```

```plaintext
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  13.600 μs …  8.136 ms  ┊ GC (min … max): 0.00% … 94.38%
 Time  (median):     16.300 μs              ┊ GC (median):    0.00%
 Time  (mean ± σ):   18.854 μs ± 81.543 μs  ┊ GC (mean ± σ):  4.07% ±  0.94%

    █▆▄▄                                                       
  ▃▆████▆▄▅▅█▆▆▆▄▃▃▃▂▂▂▂▂▂▂▁▃▄▆▇▄▃▄▃▅▅▅▆▄▄▅▄▅▃▃▃▃▃▃▂▃▂▂▂▂▂▂▂▂ ▃
  13.6 μs         Histogram: frequency by time        27.6 μs <

 Memory estimate: 18.19 KiB, allocs estimate: 8.
```



```julia
adnlp = ADNLPModel(β -> myfun(β, X, y), zeros(p + 1))
@benchmark grad(adnlp, β)
```

```plaintext
BenchmarkTools.Trial: 3658 samples with 1 evaluation.
 Range (min … max):  1.311 ms …   4.732 ms  ┊ GC (min … max): 0.00% … 67.88%
 Time  (median):     1.343 ms               ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.365 ms ± 185.183 μs  ┊ GC (mean ± σ):  0.69% ±  3.73%

       ▄██▇▅▃                                                  
  ▂▃▄▆████████▇▄▃▃▂▂▂▂▂▂▂▁▁▁▂▁▁▁▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▂▁▁▁▂▂▂▃▃▃▃▃▃ ▃
  1.31 ms         Histogram: frequency by time        1.54 ms <

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
 Range (min … max):  203.600 μs … 452.100 μs  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     207.600 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   208.450 μs ±   4.586 μs  ┊ GC (mean ± σ):  0.00% ± 0.00%

     ▂▁█▆▁   ▁ ▃▂    ▁                                           
  ▁▂▅█████▅▆▇█████▅▆██▆█▅▄▃▄▅▆▄▅▄▃▂▃▃▂▂▂▂▂▂▂▂▂▂▂▂▂▁▁▁▂▁▂▁▁▁▁▁▁▁ ▃
  204 μs           Histogram: frequency by time          220 μs <

 Memory estimate: 496 bytes, allocs estimate: 1.
```





Take these benchmarks with a grain of salt. They are being run on a github actions server with global variables.
If you want to make an informed option, you should consider performing your own benchmarks.

