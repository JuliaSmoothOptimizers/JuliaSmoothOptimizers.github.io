# This file was generated, do not modify it. # hide
ρ = 0.0 # First iteration

B = Symmetric(hess(nlp, x), :L)
factor = cholesky(B + ρ * I, check=false)
while !issuccess(factor)
  ρ = max(1e-8, 10ρ)
  factor = cholesky(B + ρ * I, check=false)
end
d = factor \ -grad(nlp, x)