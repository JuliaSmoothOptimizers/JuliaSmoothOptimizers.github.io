#=
When you know the derivatives of your optimization problem, it is frequently more efficient to use them directly instead of relying on automatic differentiation.
For that purpose, we have created `ManualNLPModels`.

For instance, in the logistic regression problem, we have a model
$h_{\beta}(x) = \sigma(\hat{x}^T \beta) = \sigma(\beta_0 + x^T\beta_{1:p})$,
where
$\hat{x} = \begin{bmatrix} 1 \\ x \end{bmatrix}$.
The value of $\beta$ is found by finding the minimum of the negavitve of the log-likelihood function.

$$\ell(\beta) = -\frac{1}{n} \sum_{i=1}^n y_i \ln \big(h_{\beta}(x_i)\big) + (1 - y_i) \ln\big(1 - h_{\beta}(x_i)\big).$$

We'll input the gradient of this function manually. It is given by

$$\nabla \ell(\beta) = \frac{-1}{n} \sum_{i=1}^n \big(y_i - h_{\beta}(x_i)\big) \hat{x}_i = \frac{1}{n} \begin{bmatrix} e^T \\ X^T \end{bmatrix} (h_{\beta}(X) - y),$$

where $e$ is the vector with all components equal to 1.
=#

using ManualNLPModels
using LinearAlgebra

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

#=
Notice that the `grad` function must modify the first argument so you don't waste memory creating arrays.

Only the `obj`, `grad` and `grad!` functions will be defined for this model, so you need to choose your solver carefully.
We'll use `lbfgs` from `JSOSolvers.jl`.
=#

using JSOSolvers

output = lbfgs(nlp)
βsol = output.solution
ŷ = round.(h(βsol, X))
sum(ŷ .== y) / n

#=
We can compare against other approaches.
=#
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

#

using ADNLPModels

@benchmark begin
  adnlp = ADNLPModel(β -> myfun(β, X, y), zeros(p + 1))
  output = with_logger(NullLogger()) do
    lbfgs(adnlp)
  end
end

#

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

# Or just the grad calls:

#
using NLPModels

@benchmark grad(nlp, β)

#

adnlp = ADNLPModel(β -> myfun(β, X, y), zeros(p + 1))
@benchmark grad(adnlp, β)

#

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

#=
Take these benchmarks with a grain of salt. They are being run on a github actions server with global variables.
If you want to make an informed option, you should consider performing your own benchmarks.
=#