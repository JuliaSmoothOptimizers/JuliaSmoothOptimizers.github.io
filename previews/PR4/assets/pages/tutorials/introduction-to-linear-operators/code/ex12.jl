# This file was generated, do not modify it. # hide
using SparseArrays, Plots
gr(size=(600,600))

A = HeatEquationOp(1.0, 20, 0.1, 0.1)
spy(sparse(Matrix(A)))
png(joinpath(@OUTPUT, "spy")) # hide