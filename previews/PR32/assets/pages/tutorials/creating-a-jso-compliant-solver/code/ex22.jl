# This file was generated, do not modify it. # hide
using SolverBenchmark

solvers = Dict(:newton => newton, :lbfgs => lbfgs)
stats = bmark_solvers(solvers, problems)