# This file was generated, do not modify it. # hide
A = rand(5,5)
opA = LinearOperator(A)
I = [1;3;5]
J = 2:4
A[I,J] * ones(3)