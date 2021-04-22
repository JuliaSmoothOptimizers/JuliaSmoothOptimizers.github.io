# This file was generated, do not modify it. # hide
using LinearOperators

prod(v) = [3v[1] - v[2]; 2v[1] + 2v[2]]
A = LinearOperator(
  Float64, # element type
  2,       # number of rows
  2,       # number of columns
  false,   # symmetric?
  false,   # Hermitian?
  prod     # Function defining v → Av
)

@show A
A * ones(2)