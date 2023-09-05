@def title = "Creating an ADNLPModels backend that supports multiple precisions"
@def showall = true
@def tags = ["models", "automatic differentiation", "multi-precision", "tests"]

\preamble{Tangi Migot}


[![OptimizationProblems 0.7.3](https://img.shields.io/badge/OptimizationProblems-0.7.3-8b0000?style=flat-square&labelColor=cb3c33)](https://jso.dev/OptimizationProblems.jl/stable/)
![ForwardDiff 0.10.36](https://img.shields.io/badge/ForwardDiff-0.10.36-000?style=flat-square&labelColor=999)
[![NLPModels 0.20.0](https://img.shields.io/badge/NLPModels-0.20.0-8b0000?style=flat-square&labelColor=cb3c33)](https://jso.dev/NLPModels.jl/stable/)
![DataFrames 1.6.1](https://img.shields.io/badge/DataFrames-1.6.1-000?style=flat-square&labelColor=999)
[![ADNLPModels 0.7.0](https://img.shields.io/badge/ADNLPModels-0.7.0-8b0000?style=flat-square&labelColor=cb3c33)](https://jso.dev/ADNLPModels.jl/stable/)
[![JSOSolvers 0.11.0](https://img.shields.io/badge/JSOSolvers-0.11.0-006400?style=flat-square&labelColor=389826)](https://jso.dev/JSOSolvers.jl/stable/)

```julia
using ADNLPModels, ForwardDiff, NLPModels, OptimizationProblems
```




One of the main strengths of Julia for scientific computing is its native usage of [arbitrary precision arithmetic](https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/#Arbitrary-Precision-Arithmetic).
The same can be exploited for optimization models and solvers.
In the organization [JuliaSmoothOptimizers](https://jso.dev), the package [ADNLPModels.jl](https://github.com/JuliaSmoothOptimizers/ADNLPModels.jl) provides automatic differentiation (AD)-based model implementations that conform to the NLPModels API.
This package is modular in the sense that it implements a backend system allowing the user to use essentially any AD system available, see [ADNLPModels.jl/dev/backend/](https://jso.dev/ADNLPModels.jl/dev/backend/) for a tutorial.

Note that most of the solvers available in [JuliaSmoothOptimizers](https://jso.dev) will accept generic types.
For instance, it is possible to use the classical L-BFGS method implemented in [JSOSolvers.jl](https://github.com/JuliaSmoothOptimizers/JSOSolvers.jl/) in single precision.

```julia
using JSOSolvers
f(x) = (x[1] - 1)^2 + 100*(x[2] - x[1]^2)^2
x32 = Float32[-1.2; 1.0]
nlp = ADNLPModel(f, x32)
stats = lbfgs(nlp)
print(stats)
```

```plaintext
Generic Execution stats
  status: first-order stationary
  objective value: 0.00036198387
  primal feasibility: 0.0
  dual feasibility: 0.031313986
  solution: [0.9810229f0  0.9622698f0]
  iterations: 33
  elapsed time: 4.492151975631714
```





To design a multi-precision algorithm, we would also need to evaluate the model at a different precision, but this fails.

```julia
x16 = Float16[-1.2; 1.0]
grad(nlp, x16)
```

```plaintext
Error: Invalid Tag object:
  Expected ForwardDiff.Tag{typeof(Main.var"##WeaveSandBox#292".f), Float16},
  Observed ForwardDiff.Tag{typeof(Main.var"##WeaveSandBox#292".f), Float32}.
```





In this tutorial, we will show how to modify the AD-backend in `ADNLPModel` to overcome this issue.

## Multiprecision ADNLPModels

Let's define the famous Rosenbrock function

$$
f(x) = (x_1 - 1)^2 + 100(x_2 - x_1^2)^2
$$

with starting point $x^0 = (-1.2,1.0)$, and its associated `ADNLPModel`.

```julia
f(x) = (x[1] - 1)^2 + 100*(x[2] - x[1]^2)^2
T = Float64
x0 = T[-1.2; 1.0]
nlp = ADNLPModel(f, x0)
```

```plaintext
ADNLPModel - Model with automatic differentiation backend ADModelBackend{
  ForwardDiffADGradient,
  ForwardDiffADHvprod,
  EmptyADbackend,
  EmptyADbackend,
  EmptyADbackend,
  ForwardDiffADHessian,
  EmptyADbackend,
}
  Problem name: Generic
   All variables: ████████████████████ 2      All constraints: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            free: ████████████████████ 2                 free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0              low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
          infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: (  0.00% sparsity)   3               linear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
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





The [NLPModels](https://github.com/JuliaSmoothOptimizers/NLPModels.jl) are usually parametrically typed by the vector and element type of `x0` and use this type for some pre-computations.
We now see how `ADNLPModel` can still be used for other types.

### Objective Evaluation

Note that in the input of the `ADNLPModel` constructor only the function `x0` is typed, while the objective function `f` can be generic.
Therefore, the function `obj(nlp, x)` will return an element of type `eltype(x)`.

```julia
x32 = Float32[-1.2; 1.0]
obj(nlp, x32) # type Float32
```

```plaintext
24.200005f0
```





### Gradient Evaluation

An `ADNLPModel` is parametrically typed by the vector and element type of `x0` and use this type for some pre-computations.
For instance, `ADNLPModel` may compute some default backend based on the expected element type to speed up the AD process.

```julia
adbackend = get_adbackend(nlp)
adbackend.gradient_backend # returns information about the default backend for the gradient computation.
```

```plaintext
ADNLPModels.ForwardDiffADGradient(ForwardDiff.GradientConfig{ForwardDiff.Tag{typeof(Main.var"##WeaveSandBox#292".f), Float64}, Float64, 2, Vector{ForwardDiff.Dual{ForwardDiff.Tag{typeof(Main.var"##Wea
veSandBox#292".f), Float64}, Float64, 2}}}((Partials(1.0, 0.0), Partials(0.0, 1.0)), ForwardDiff.Dual{ForwardDiff.Tag{typeof(Main.var"##WeaveSandBox#292".f), Float64}, Float64, 2}[Dual{ForwardDiff.Tag
{typeof(Main.var"##WeaveSandBox#292".f), Float64}}(6.93760713221863e-310,0.0,6.93762797366486e-310), Dual{ForwardDiff.Tag{typeof(Main.var"##WeaveSandBox#292".f), Float64}}(0.0,6.9376614397413e-310,5.0
e-324)]))
```





We now show how to define your gradient-backend to keep the genericity in two steps:
- Define a new structure `GenericGradientBackend <: ADNLPModels.ADBackend`;
- Implements the function `ADNLPModels.gradient!` for this new backend.

We will use [ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl) to compute the gradient.
Note that the same can be done using alternatives such as [ReverseDiff.jl](https://github.com/JuliaDiff/ReverseDiff.jl) or [Zygote.jl](https://github.com/FluxML/Zygote.jl).

```julia
struct GenericGradientBackend <: ADNLPModels.ADBackend end
GenericGradientBackend(args...; kwargs...) = GenericGradientBackend()

function ADNLPModels.gradient!(::GenericGradientBackend, g, f, x)
  return ForwardDiff.gradient!(g, f, x)
end
```




Once the new backend is defined it is possible to use it in the `ADNLPModel` constructor:

```julia
nlp = ADNLPModel(f, x0, gradient_backend = GenericGradientBackend)
```

```plaintext
ADNLPModel - Model with automatic differentiation backend ADModelBackend{
  Main.var"##WeaveSandBox#292".GenericGradientBackend,
  ForwardDiffADHvprod,
  EmptyADbackend,
  EmptyADbackend,
  EmptyADbackend,
  ForwardDiffADHessian,
  EmptyADbackend,
}
  Problem name: Generic
   All variables: ████████████████████ 2      All constraints: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            free: ████████████████████ 2                 free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0              low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
          infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: (  0.00% sparsity)   3               linear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
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





It is then possible to use the NLPModel API with any precision and compute the gradient

```julia
grad(nlp, x32) # returns a vector of Float32
```

```plaintext
2-element Vector{Float32}:
 -215.60004
  -88.000015
```





or the gradient in-place

```julia
x16 = Float16[-1.2; 1.0]
g = similar(x16)
grad!(nlp, x16, g) # returns a vector of Float16
```

```plaintext
2-element Vector{Float16}:
 -215.9
  -88.06
```





The same can be done for the other backends jacobian, hessian, etc.

## Multiprecision test problems

Designing a multi-precision algorithm is very often connected with benchmarking and test problems.
The package [OptimizationProblems.jl](https://github.com/JuliaSmoothOptimizers/OptimizationProblems.jl) provides a collection of optimization problems in JuMP and ADNLPModels syntax, see [introduction to OptimizationProblems.jl tutorial](https://jso.dev/tutorials/introduction-to-optimizationproblems/).

This package provides a `DataFrame` with all the information on the implemented problems.

```julia
OptimizationProblems.meta[!, :name] # access the names of the available  problems
```

```plaintext
372-element Vector{String}:
 "AMPGO02"
 "AMPGO03"
 "AMPGO04"
 "AMPGO05"
 "AMPGO06"
 "AMPGO07"
 "AMPGO08"
 "AMPGO09"
 "AMPGO10"
 "AMPGO11"
 ⋮
 "triangle_deer"
 "triangle_pacman"
 "triangle_turtle"
 "tridia"
 "vardim"
 "vibrbeam"
 "watson"
 "woods"
 "zangwil3"
```





In the following example, we use the problem `HS68`.

```julia
using OptimizationProblems.ADNLPProblems
name = :hs68
T = Float64
# Returns an `ADNLPModel` of element type `T` with GenericGradientBackend
nlp = eval(name)(type = Val(T), gradient_backend = GenericGradientBackend)
```

```plaintext
ADNLPModel - Model with automatic differentiation backend ADModelBackend{
  Main.var"##WeaveSandBox#292".GenericGradientBackend,
  ForwardDiffADHvprod,
  ForwardDiffADJprod,
  ForwardDiffADJtprod,
  ForwardDiffADJacobian,
  ForwardDiffADHessian,
  ForwardDiffADGHjvprod,
}
  Problem name: hs68
   All variables: ████████████████████ 4      All constraints: ████████████████████ 2     
            free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         low/upp: ████████████████████ 4              low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                fixed: ████████████████████ 2     
          infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: (  0.00% sparsity)   10              linear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                    nonlinear: ████████████████████ 2     
                                                         nnzj: (  0.00% sparsity)   8     

  Counters:
             obj: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 grad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 cons: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
        cons_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0             cons_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 jcon: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           jgrad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                  jac: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0              jac_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         jac_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                jprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0            jprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
       jprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               jtprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0           jtprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
      jtprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 hess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                hprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           jhess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               jhprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0
```





The keyword arguments other than specific to a problem (`n`, `type`) are all passed to the constructor of the `ADNLPModel`.
In the example above `GenericGradientBackend` is used for the gradient backend.

```julia
x16 = Float16.(get_x0(nlp))
g = similar(x16)
grad!(nlp, x16, g) # returns a vector of Float16
```

```plaintext
4-element Vector{Float16}:
 -0.3704
 -0.0
  0.368
 -0.0
```





We should pay additional attention when using multiple precisions as casting, for instance `x0`, from `Float64` into `Float16` implies that rounding errors occur.
Therefore, `x0` is different than `x16`, and the gradients evaluated for these values too.

Feel free to look at [OptimizationProblems.jl documentation](https://jso.dev/OptimizationProblems.jl/dev/) to learn more or the tutorials at [juliasmoothoptimizers.github.io](https://jso.dev).
