# This file was generated, do not modify it. # hide
problems = [
  ADNLPModel(x -> x[1]^2 + 4 * x[2]^2, ones(2)),
  ADNLPModel(x -> (1 - x[1])^2 + 100 * (x[2] - x[1]^2)^2, [-1.2; 1.0]),
  ADNLPModel(x -> x[1]^2 + x[2] - 11 + (x[1] + x[2]^2 - 7)^2, [-1.0; 1.0]),
  ADNLPModel(x -> log(exp(-x[1] - 2x[2]) + exp(x[1] + 2) + exp(2x[2] - 1)), zeros(2))
];