# This file was generated, do not modify it. # hide
using LinearOperators, LinearAlgebra # hide
m, n = 50, 30
A = rand(m, n) + im * rand(m, n)
op = LinearOperator(A)
v = rand(n)
res = zeros(eltype(A), m)
res2 = copy(res)
mul!(res2, op, v) # compile 3-args mul!
al = @allocated mul!(res, op, v) # op * v, store result in res
println("Allocation of LinearOperator mul! product = $al")
v = rand(n)
α, β = 2.0, 3.0
mul!(res2, op, v, α, β) # compile 5-args mul!
al = @allocated mul!(res, op, v, α, β) # α * op * v + β * res, store result in res
println("Allocation of LinearOperator mul! product = $al")