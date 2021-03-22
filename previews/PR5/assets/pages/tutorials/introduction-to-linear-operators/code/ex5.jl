# This file was generated, do not modify it. # hide
n = 4000
A = rand(n, n)
B = rand(n, n)
opA = LinearOperator(A)
opB = LinearOperator(B)

@show opA * opB