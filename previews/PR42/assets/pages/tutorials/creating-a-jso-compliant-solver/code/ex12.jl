# This file was generated, do not modify it. # hide
α = 1e-2
t = 1.0
fx = obj(nlp, x)
ft = obj(nlp, x + t * d)
slope = dot(grad(nlp, x), d)
while !(ft ≤ fx + t * slope)
  global t *= 0.5 # global is used because we are outside a function
  ft = obj(nlp, x + t * d)
end