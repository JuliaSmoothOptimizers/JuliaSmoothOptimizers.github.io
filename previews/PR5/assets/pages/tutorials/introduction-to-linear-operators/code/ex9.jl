# This file was generated, do not modify it. # hide
B = LBFGSOperator(5, scaling=false) # B₀ = I
H = InverseLBFGSOperator(5, scaling=false) # H₀ = I

s = rand(5)
y = rand(5)
push!(B, s, y)
push!(H, s, y)

q = rand(5)
Bq = q + dot(y, q) / dot(y, s) * y - dot(s, q) / dot(s, s) * s
Hauxq = q - dot(s, q) / dot(y, s) * y
Hq = Hauxq - dot(y, Hauxq) / dot(y, s) * s + dot(s, q) / dot(y, s) * s

norm(B * q - Bq), norm(H * q - Hq), norm(B * H * q - q)