# This file was generated, do not modify it. # hide
@time A * B
@time opA * opB

v = rand(n)
@time A * (B * v)
@time (opA * opB) * v;