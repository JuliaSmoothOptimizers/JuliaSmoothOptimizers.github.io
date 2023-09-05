@def title = "Introduction to Linear Operators"
@def showall = true
@def tags = ["linear-algebra", "linear-operators"]

\preamble{Geoffroy Leconte and Dominique Orban}


![JSON 0.21.4](https://img.shields.io/badge/JSON-0.21.4-000?style=flat-square&labelColor=999)
[![LinearOperators 2.5.2](https://img.shields.io/badge/LinearOperators-2.5.2-4b0082?style=flat-square&labelColor=9558b2)](https://jso.dev/LinearOperators.jl/stable/)
[![Krylov 0.9.4](https://img.shields.io/badge/Krylov-0.9.4-4b0082?style=flat-square&labelColor=9558b2)](https://jso.dev/Krylov.jl/stable/)
![FFTW 1.7.1](https://img.shields.io/badge/FFTW-1.7.1-000?style=flat-square&labelColor=999)



[LinearOperators.jl](https://jso.dev/LinearOperators.jl/stable) is a package for matrix-like operators. Linear operators are defined by how they act on a vector, which is useful in a variety of situations where you don't want to materialize the matrix.

\toc

This section of the documentation describes a few uses of LinearOperators.

## Using matrices

Operators may be defined from matrices and combined using the usual operations, but the result is deferred until the operator is applied.

```julia
using LinearOperators, Random, SparseArrays
Random.seed!(0)

A1 = rand(5,7)
A2 = sprand(7,3,.3)
op1 = LinearOperator(A1)
op2 = LinearOperator(A2)
op = op1 * op2  # Does not form A1 * A2
x = rand(3)
y = op * x
```

```plaintext
5-element Vector{Float64}:
 0.24766385713448147
 0.34471427066907173
 0.6399025892338569
 0.246664873173519
 0.5258420478788777
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

```plaintext
1.148733996146629e-13
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

```plaintext
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

```plaintext
3.3612925285989963e-16
```



```julia
transpose(dft) * y
```

```plaintext
10-element Vector{ComplexF64}:
   0.7113168325963566 - 0.0im
   0.2148297961020408 - 0.0im
   0.9453427110792467 - 0.0im
   0.7309321298104021 - 0.0im
  0.23194328498409336 - 0.0im
   0.9501874396162999 - 0.0im
   0.5123847829172379 - 0.0im
   0.9037088931078092 - 0.0im
 0.005729552514365821 + 0.0im
   0.2588088046728426 - 0.0im
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

```plaintext
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

```plaintext
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

```plaintext
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

```plaintext
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

```plaintext
ex = InexactError(:Float64, Float64, 0.47507530806279163 - 0.3832301880068187im)
```



```julia
try
  Matrix(dft) # ERROR: tried to create a Matrix of Float64
catch ex
  println("ex = $ex")
end

# Using external modules
```

```plaintext
ex = InexactError(:Float64, Float64, 0.8090169943749475 - 0.5877852522924731im)
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

```plaintext
2.3624810325472306e-13
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

```plaintext
3.919077465054229e-13
```





There is also a LSR1 operator that behaves similarly to these two.

## Restriction, extension and slices

The restriction operator restricts a vector to a set of indices.

```julia
v = collect(1:5)
R = opRestriction([2;5], 5)
R * v
```

```plaintext
2-element Vector{Int64}:
 2
 5
```





Notice that it corresponds to a matrix with rows of the identity given by the indices.

```julia
Matrix(R)
```

```plaintext
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

```plaintext
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

```plaintext
3-element Vector{Float64}:
 1.043315409692812
 1.126646200633167
 1.2315932943898407
```



```julia
opRestriction(I, 5) * opA * opExtension(J, 5) * ones(3)
```

```plaintext
3-element Vector{Float64}:
 1.043315409692812
 1.126646200633167
 1.2315932943898407
```





A main difference with matrices, is that slices **do not** return vectors nor numbers.

```julia
opA[1,:] * ones(5)
```

```plaintext
1-element Vector{Float64}:
 1.9634567072673046
```



```julia
opA[:,1] * ones(1)
```

```plaintext
5-element Vector{Float64}:
 0.02203447865143171
 0.18781833339603016
 0.1692361439290926
 0.20276666600590854
 0.24969824326802326
```



```julia
opA[1,1] * ones(1)
```

```plaintext
1-element Vector{Float64}:
 0.02203447865143171
```

