# This file was generated, do not modify it. # hide
B = LBFGSOperator(20)
H = InverseLBFGSOperator(20)
r = 0.0
for i = 1:100
  global r
  s = rand(20)
  y = rand(20)
  push!(B, s, y)
  push!(H, s, y)
  r += norm(B * H * s - s)
end
r