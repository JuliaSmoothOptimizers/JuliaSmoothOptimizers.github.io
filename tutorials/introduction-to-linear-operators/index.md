@def title = "Introduction to Linear Operators"
@def showall = true
@def tags = ["linear-algebra", "linear-operators"]

\preamble{Geoffroy Leconte and Dominique Orban}



[LinearOperators.jl](https://juliasmoothoptimizers.github.io/LinearOperators.jl/stable) is a package for matrix-like operators. Linear operators are defined by how they act on a vector, which is useful in a variety of situations where you don't want to materialize the matrix.

\toc

This section of the documentation describes a few uses of LinearOperators.

## Using matrices

Operators may be defined from matrices and combined using the usual operations, but the result is deferred until the operator is applied.

```julia
using LinearOperators, SparseArrays
A1 = rand(5,7)
A2 = sprand(7,3,.3)
op1 = LinearOperator(A1)
op2 = LinearOperator(A2)
op = op1 * op2  # Does not form A1 * A2
x = rand(3)
y = op * x
```

```
5-element Vector{Float64}:
 0.2090075410658057
 0.2006149794391634
 0.15198579975119209
 0.4312396553686765
 0.228422034577769
```





## Inverse

Operators may be defined to represent (approximate) inverses.

```julia
using LinearAlgebra
A = rand(5,5)
A = A' * A
op = opCholesky(A)  # Use, e.g., as a preconditioner
v = rand(5)
norm(A \ v - op * v) / norm(v)
```

```
5.123386247878985e-15
```





In this example, the Cholesky factor is computed only once and can be used many times transparently.

## mul!

It is often useful to reuse the memory used by the operator.
For that reason, we can use `mul!` on operators as if we were using matrices
using preallocated vectors:

```julia
using LinearOperators, LinearAlgebra # hide
m, n = 50, 30
A = rand(m, n) + im * rand(m, n)
op = LinearOperator(A)
v = rand(n)
res = zeros(eltype(A), m)
res2 = copy(res)
mul!(res2, op, v) # compile 3-args mul!
al = @allocated mul!(res, op, v) # op * v, store result in res
println("Allocation of LinearOperator mul! product = $al")
v = rand(n)
α, β = 2.0, 3.0
mul!(res2, op, v, α, β) # compile 5-args mul!
al = @allocated mul!(res, op, v, α, β) # α * op * v + β * res, store result in res
println("Allocation of LinearOperator mul! product = $al")
```

```
Allocation of LinearOperator mul! product = 0
Allocation of LinearOperator mul! product = 0
```





## Using functions

Operators may be defined from functions. They have to be based on the 5-arguments `mul!` function.
In the example below, the transposed isn't defined, but it may be inferred from the conjugate transposed.
Missing operations are represented as `nothing`.
You will have deal with cases where `β == 0` and `β != 0` separately because `*` will allocate an uninitialized `res` vector that
may contain `NaN` values, and `0 * NaN == NaN`.

```julia
using FFTW
function mulfft!(res, v, α, β)
  if β == 0
    res .= α .* fft(v)
  else
    res .= α .* fft(v) .+ β .* res
  end
end
function mulifft!(res, w, α, β)
  if β == 0
    res .= α .* ifft(w)
  else
    res .= α .* ifft(w) .+ β .* res
  end
end
dft = LinearOperator(ComplexF64, 10, 10, false, false,
                     mulfft!,
                     nothing,       # will be inferred
                     mulifft!)
x = rand(10)
y = dft * x
norm(dft' * y - x)  # DFT is a unitary operator
```

```
3.597533769998862e-16
```



```julia
transpose(dft) * y
```

```
10-element Vector{ComplexF64}:
  0.8639196387611643 - 0.0im
  0.0955806766661847 - 0.0im
 0.08378893040147012 - 0.0im
  0.8325526447869684 - 0.0im
  0.7812450893509602 - 0.0im
  0.6237994365317306 - 0.0im
  0.9263944055633124 - 0.0im
  0.7791798322125566 - 0.0im
  0.6626345949352839 + 0.0im
  0.7385336370595803 - 0.0im
```





Another example:

```julia
function customfunc!(res, v, α, β)
  if β == 0
    res[1] = (v[1] + v[2]) * α
    res[2] = v[2] * α
  else
    res[1] = (v[1] + v[2]) * α + res[1] * β
    res[2] = v[2] * α + res[2] * β
  end
end
function tcustomfunc!(res, w, α, β)
  if β == 0
    res[1] = w[1] * α
    res[2] =  (w[1] + w[2]) * α
  else
    res[1] = w[1] * α + res[1] * β
    res[2] =  (w[1] + w[2]) * α + res[2] * β
  end
end
op = LinearOperator(Float64, 2, 2, false, false,
                    customfunc!,
                    nothing,
                    tcustomfunc!)
```

```
Linear operator
  nrow: 2
  ncol: 2
  eltype: Float64
  symmetric: false
  hermitian: false
  nprod:   0
  ntprod:  0
  nctprod: 0
```





Operators can also be defined with the 3-args `mul!` function:

```julia
op2 = LinearOperator(Float64, 2, 2, false, false,
                     (res, v) -> customfunc!(res, v, 1.0, 0.),
                     nothing,
                     (res, w) -> tcustomfunc!(res, w, 1.0, 0.))
```

```
Linear operator
  nrow: 2
  ncol: 2
  eltype: Float64
  symmetric: false
  hermitian: false
  nprod:   0
  ntprod:  0
  nctprod: 0
```





When using the 5-args `mul!` with the above operator, some vectors will be allocated (only at the first call):

```julia
res, a = zeros(2), rand(2)
mul!(res, op2, a) # compile
println("allocations 1st call = ", @allocated mul!(res, op2, a, 2.0, 3.0))
println("allocations 2nd call = ", @allocated mul!(res, op2, a, 2.0, 3.0))
```

```
allocations 1st call = 80
allocations 2nd call = 0
```





Make sure that the type passed to `LinearOperator` is correct, otherwise errors may occur.

```julia
using LinearOperators, FFTW # hide
dft = LinearOperator(Float64, 10, 10, false, false,
                     mulfft!,
                     nothing,
                     mulifft!)
v = rand(10)
println("eltype(dft)         = $(eltype(dft))")
println("eltype(v)           = $(eltype(v))")
```

```
eltype(dft)         = Float64
eltype(v)           = Float64
```



```julia
try
  dft * v     # ERROR: expected Vector{Float64}
catch ex
  println("ex = $ex")
end
```

```
ex = InexactError(:Float64, Float64, -0.16316596251395854 + 0.6151582477792
934im)
```



```julia
try
  Matrix(dft) # ERROR: tried to create a Matrix of Float64
catch ex
  println("ex = $ex")
end

# Using external modules
```

```
ex = InexactError(:Float64, Float64, 0.8090169943749475 - 0.587785252292473
1im)
```





It is possible to use certain modules made for matrices that do not need to access specific elements of their input matrices, and only use operations implemented within LinearOperators, such as `mul!`, `*`, `+`, ...
For example, we show the solution of a linear system using [`Krylov.jl`](https://github.com/JuliaSmoothOptimizers/Krylov.jl):

```julia
using Krylov
A = rand(5, 5)
opA = LinearOperator(A)
opAAT = opA + opA'
b = rand(5)
(x, stats) = minres(opAAT, b)
norm(b - opAAT * x)
```

```
5.174129014538037e-13
```





## Limited memory BFGS and SR1

Two other useful operators are the Limited-Memory BFGS in forward and inverse form.

```julia
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
```

```
4.210954776704542e-13
```





There is also a LSR1 operator that behaves similarly to these two.

## Restriction, extension and slices

The restriction operator restricts a vector to a set of indices.

```julia
v = collect(1:5)
R = opRestriction([2;5], 5)
R * v
```

```
2-element Vector{Int64}:
 2
 5
```





Notice that it corresponds to a matrix with rows of the identity given by the indices.

```julia
Matrix(R)
```

```
2×5 Matrix{Int64}:
 0  1  0  0  0
 0  0  0  0  1
```





The extension operator is the transpose of the restriction. It extends a vector with zeros.

```julia
v = collect(1:2)
E = opExtension([2;5], 5)
E * v
```

```
5-element Vector{Int64}:
 0
 1
 0
 0
 2
```





With these operators, we define the slices of an operator `op`.

```julia
A = rand(5,5)
opA = LinearOperator(A)
I = [1;3;5]
J = 2:4
A[I,J] * ones(3)
```

```
3-element Vector{Float64}:
 1.0213331097020752
 1.8384568702252353
 1.2519959516787202
```



```julia
opRestriction(I, 5) * opA * opExtension(J, 5) * ones(3)
```

```
3-element Vector{Float64}:
 1.0213331097020752
 1.8384568702252353
 1.2519959516787202
```





A main difference with matrices, is that slices **do not** return vectors nor numbers.

```julia
opA[1,:] * ones(5)
```

```
1-element Vector{Float64}:
 1.264969622765566
```



```julia
opA[:,1] * ones(1)
```

```
5-element Vector{Float64}:
 0.217289989780464
 0.8072056013829091
 0.15799998724825803
 0.7931044933169284
 0.9651586890307786
```



```julia
opA[1,1] * ones(1)
```

```
1-element Vector{Float64}:
 0.217289989780464
```


