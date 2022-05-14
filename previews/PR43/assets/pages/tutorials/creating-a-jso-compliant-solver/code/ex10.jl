# This file was generated, do not modify it. # hide
B = -Symmetric(hess(nlp, x), :L) # Since the last one is positive definite, this one shouldn't be
factor = cholesky(B, check=false)
issuccess(factor)