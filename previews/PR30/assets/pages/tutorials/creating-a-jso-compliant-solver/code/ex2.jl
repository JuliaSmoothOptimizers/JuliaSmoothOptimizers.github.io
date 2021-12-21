# This file was generated, do not modify it. # hide
using ADNLPModels

nlp = ADNLPModel(
  x -> (x[1] - 1)^2 + 4 * (x[2] - x[1]^2)^2, # function
  [-1.2; 1.0] # starting point
)