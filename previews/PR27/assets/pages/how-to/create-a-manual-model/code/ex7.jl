# This file was generated, do not modify it. # hide
adnlp = ADNLPModel(β -> myfun(β, X, y), zeros(p + 1))
@benchmark grad(adnlp, β)