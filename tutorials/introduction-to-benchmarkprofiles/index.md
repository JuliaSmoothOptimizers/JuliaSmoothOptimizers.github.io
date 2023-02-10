@def title = "Introduction to BenchmarkProfiles"
@def showall = true
@def tags = ["benchmarking"]

\preamble{Abel Soares Siqueira and Dominique Orban}


![JSON 0.21.3](https://img.shields.io/badge/JSON-0.21.3-000?style=flat-square&labelColor=fff")
[![BenchmarkProfiles 0.4.3](https://img.shields.io/badge/BenchmarkProfiles-0.4.3-006400?style=flat-square&labelColor=389826")](https://juliasmoothoptimizers.github.io/BenchmarkProfiles.jl/stable/)
![Plots 1.38.5](https://img.shields.io/badge/Plots-1.38.5-000?style=flat-square&labelColor=fff")



This tutorial is essentially a collection of examples.

## Performance Profile

Performance profiles are straightforward to use. The input is a matrix `T` with entries `T[i,j]` indicating the cost to solve problem `i` using solver `j`. Cost can be, for instance, elapsed time, or number of evaluations. The cost should be positive. If any cost is zero, all measures will be shifted by 1.

Basic usage:

```julia
using BenchmarkProfiles, Random, Plots

Random.seed!(0)

T = 10 * rand(25, 3)
performance_profile(PlotsBackend(), T, ["Solver 1", "Solver 2", "Solver 3"])
```

![](figures/index_1_1.png)



A negative or infinite cost indicates a failure:

```julia
T[2:20,1] .= Inf
performance_profile(PlotsBackend(), T, ["Solver 1", "Solver 2", "Solver 3"])
```

![](figures/index_2_1.png)



Here's an example with a strongly superior solver.

```julia
T[:,2] = 100T[:,3]
performance_profile(PlotsBackend(), T, ["Solver 1", "Solver 2", "Solver 3"])
```

![](figures/index_3_1.png)



`Plots` arguments can be passed to `performance_profile()` or used as they normally would be with `Plots`.
In the example below, we pass `xlabel` to `performance_profile` and set `ylabel` through `ylabel!`.

```julia
using Plots

T = 10 * rand(25, 3)
performance_profile(PlotsBackend(), T, ["Solver 1", "Solver 2", "Solver 3"],
      lw=2, c=:black, linestyles=[:solid, :dash, :dot], xlabel="τ")
ylabel!("ρ(τ)")
```

![](figures/index_4_1.png)
