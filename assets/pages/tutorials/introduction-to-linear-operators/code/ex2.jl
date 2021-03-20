# This file was generated, do not modify it. # hide
prod(v) = [3v[1] - v[2]; 2v[1] + 2v[2]]
tprod(v) = [3v[1] + 2v[2]; -v[1] + 2v[2]]

A = LinearOperator(Float64, 2, 2, false, false, prod, tprod)

transpose(A) * ones(2)