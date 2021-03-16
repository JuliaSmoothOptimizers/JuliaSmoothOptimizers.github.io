# This file was generated, do not modify it. # hide
A = rand(5,5)
A = A' * A
op = opCholesky(A)  # Use, e.g., as a preconditioner
v = rand(5)

norm(A \ v - op * v) / norm(v)