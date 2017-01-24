# [Julia Smooth Optimizers](https://JuliaSmoothOptimizers.github.io) - [![](assets/github.png)](https://github.com/JuliaSmoothOptimizers/)

Here you will find a collection of Julia packages for Nonlinear Optimization.
These packages provide the tools needed for creating optimization problems and
methods, but also provide access for optimization problems and methods.

See each package status [here](https://JuliaSmoothOptimizers.github.io/status/).

## Optimization Problems

- [NLPModels.jl](https://github.com/JuliaSmoothOptimizers/NLPModels.jl): Defines data structures for nonlinear
  optimization models. Includes models for user-provided functions, automatic
  differentiation, [JuMP](https://github.com/JuliaOpt/JuMP.jl) /
  [MathProgBase](https://github.com/JuliaOpt/MathProgBase.jl) models, and the
  abstract models used by [CUTEst.jl](https://github.com/JuliaSmoothOptimizers/CUTEst.jl) and
  [AmplNLReader.jl](https://github.com/JuliaSmoothOptimizers/AmplNLReader.jl).
- [CUTEst.jl](https://github.com/JuliaSmoothOptimizers/CUTEst.jl): Provides access to the **Constrained and
  Unconstrained Testing Environment with safe threads (CUTEST)** repository of
  problems. Uses [NLPModels.jl](https://github.com/JuliaSmoothOptimizers/NLPModels.jl).
- [AmplNLReader.jl](https://github.com/JuliaSmoothOptimizers/AmplNLReader.jl): Provides access to AMPL Models.
  Uses [NLPModels.jl](https://github.com/JuliaSmoothOptimizers/NLPModels.jl).
- [OptimizationProblems.jl](https://github.com/JuliaSmoothOptimizers/OptimizationProblems.jl): Implements
  several problem in JuMP format. Can be used with
  [NLPModels](https://github.com/JuliaSmoothOptimizers/NLPModels.jl) for easy multiplatform access to problems.

## Tools

- [Krylov.jl](https://github.com/JuliaSmoothOptimizers/Krylov.jl): Implements Hand-Picked Krylov methods. For
  instance, Steihaug-Toint conjugate-gradient method for the minimization of a
  non-convex quadratic in a Trust-Region.
- [LinearOperators.jl](https://github.com/JuliaSmoothOptimizers/LinearOperators.jl): Implements linear
  operators, facilitating the use of some operations (like **Hessian-vector**
  products or **Limited BFGS** matrices). Specially useful with Krylov methods.
- [BenchmarkProfiles.jl](https://github.com/JuliaSmoothOptimizers/BenchmarkProfiles.jl):
  Implements performance profile for Julia.
  Uses and easy input and access the Plots library, enabling the use of various
  backends.

## Methods

- [Optimize.jl](https://github.com/JuliaSmoothOptimizers/Optimize.jl): Optimization Algorithms in Pure Julia.
  The focus is to provide large-scale efficient and robust methods. Uses
  [NLPModels](https://github.com/JuliaSmoothOptimizers/NLPModels.jl) for unified access to all problems above.
  Also defines tools for benchmarking and profiling codes using the same API.

## Interfaces

- [AMD.jl](https://github.com/JuliaSmoothOptimizers/AMD.jl): Julia Interface to the AMD library of Amestoy,
  Davis and Duff.
- [HSL.jl](https://github.com/JuliaSmoothOptimizers/HSL.jl): Julia Interface to the HSL Mathematical Software
  Library.
- [MUMPS.jl](https://github.com/JuliaSmoothOptimizers/MUMPS.jl): Julia Interface to MUMPS.
- [PROPACK.jl](https://github.com/JuliaSmoothOptimizers/PROPACK.jl): Julia wrapper of the PROPACK sparse SVD
  library
- [qr_mumps.jl](https://github.com/JuliaSmoothOptimizers/qr_mumps.jl): Interface to multicore QR factorization
  qr_mumps.
