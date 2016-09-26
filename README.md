# [Julia Smooth Optimizers](https://JuliaSmoothOptimizers.github.io) - [](https://github.com/JuliaSmoothOptimizers/){ .icon .icon-github }

Here you will find a collection of Julia packages for Nonlinear Optimization.
These packages provide the tools needed for creating optimization problems and
methods, but also provide access for optimization problems and methods.

See each package status [here](packages).

## Optimization Problems

- [NLPModels.jl](packages/#nlpmodelsjl): Defines data structures for nonlinear
  optimization models. Includes models for user-provided functions, automatic
  differentiation, [JuMP](https://github.com/JuliaOpt/JuMP.jl) /
  [MathProgBase](https://github.com/JuliaOpt/MathProgBase.jl) models, and the
  abstract models used by [CUTEst.jl](packages/#cutestjl) and
  [AmplNLReader.jl](packages/#amplnlreaderjl).
- [CUTEst.jl](packages/#cutestjl): Provides access to the **Constrained and
  Unconstrained Testing Environment with safe threads (CUTEST)** repository of
  problems. Uses [NLPModels.jl](packages/#nlpmodelsjl).
- [AmplNLReader.jl](packages/#amplnlreaderjl): Provides access to AMPL Models.
  Uses [NLPModels.jl](packages/#nlpmodelsjl).
- [OptimizationProblems.jl](packages/#optimizationproblemsjl): Implements
  several problem in JuMP format. Can be used with
  [NLPModels](packages/#nlpmodelsjl) for easy multiplatform access to problems.

## Tools

- [Krylov.jl](packages/#krylovjl): Implements Hand-Picked Krylov methods. For
  instance, Steihaug-Toint conjugate-gradient method for the minimization of a
  non-convex quadratic in a Trust-Region.
- [LinearOperators.jl](packages/#linearoperatorsjl): Implements linear
  operators, facilitating the use of some operations (like **Hessian-vector**
  products or **Limited BFGS** matrices). Specially useful with Krylov methods.
- [Profiles.jl](packages/#profilesjl): Implements performance profile for Julia.
  Uses and easy input and access the Plots library, enabling the use of various
  backends.

## Methods

- [Optimize.jl](packages/#optimizejl): Optimization Algorithms in Pure Julia.
  The focus is to provide large-scale efficient and robust methods. Uses
  [NLPModels](packages/#nlpmodelsjl) for unified access to all problems above.
  Also defines tools for benchmarking and profiling codes using the same API.

## Interfaces

- [AMD.jl](packages/#amdjl): Julia Interface to the AMD library of Amestoy,
  Davis and Duff.
- [HSL.jl](packages/#hsljl): Julia Interface to the HSL Mathematical Software
  Library.
- [MUMPS.jl](packages/#mumpsjl): Julia Interface to MUMPS.
- [PROPACK.jl](packages/#propackjl): Julia wrapper of the PROPACK sparse SVD
  library
- [qr_mumps.jl](packages/#qr_mumpsjl): Interface to multicore QR factorization
  qr_mumps.
