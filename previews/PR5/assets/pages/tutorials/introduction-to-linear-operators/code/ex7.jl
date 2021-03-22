# This file was generated, do not modify it. # hide
m, n = 50, 30
A = rand(50, 30)
op1 = PreallocatedLinearOperator(A)
op2 = LinearOperator(A)
v = rand(n)

op1 * v
al = @allocated for i = 1:100
  op1 * v
end
println("Allocation of op1: $al")
op2 * v
al = @allocated for i = 1:100
  op2 * v
end
println("Allocation of op2: $al")