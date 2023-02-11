@def title = "LDLFactorizations tutorial"
@def showall = true
@def tags = ["linear", "factorization", "ldlt"]

\preamble{Geoffroy Leconte}


![JSON 0.21.3](https://img.shields.io/badge/JSON-0.21.3-000?style=flat-square&labelColor=fff)
![MatrixMarket 0.3.1](https://img.shields.io/badge/MatrixMarket-0.3.1-000?style=flat-square&labelColor=fff)
[![RipQP 0.6.1](https://img.shields.io/badge/RipQP-0.6.1-006400?style=flat-square&labelColor=389826)](https://juliasmoothoptimizers.github.io/RipQP.jl/stable/)
[![SparseMatricesCOO 0.2.1](https://img.shields.io/badge/SparseMatricesCOO-0.2.1-4b0082?style=flat-square&labelColor=9558b2)](https://juliasmoothoptimizers.github.io/SparseMatricesCOO.jl/stable/)
[![QuadraticModels 0.9.3](https://img.shields.io/badge/QuadraticModels-0.9.3-8b0000?style=flat-square&labelColor=cb3c33)](https://juliasmoothoptimizers.github.io/QuadraticModels.jl/stable/)
![Plots 1.38.5](https://img.shields.io/badge/Plots-1.38.5-000?style=flat-square&labelColor=fff)
[![QPSReader 0.2.1](https://img.shields.io/badge/QPSReader-0.2.1-8b0000?style=flat-square&labelColor=cb3c33)](https://juliasmoothoptimizers.github.io/QPSReader.jl/stable/)
[![LDLFactorizations 0.10.0](https://img.shields.io/badge/LDLFactorizations-0.10.0-4b0082?style=flat-square&labelColor=9558b2)](https://juliasmoothoptimizers.github.io/LDLFactorizations.jl/stable/)
![TimerOutputs 0.5.22](https://img.shields.io/badge/TimerOutputs-0.5.22-000?style=flat-square&labelColor=fff)



LDLFactorizations.jl is a translation of Tim Davis's Concise LDLᵀ Factorization, part of [SuiteSparse](http://faculty.cse.tamu.edu/davis/suitesparse.html) with several improvements.

This package is appropriate for matrices A that possess a factorization of the
form LDLᵀ without pivoting, where L is unit lower triangular and D is *diagonal* (indefinite in general), including definite and quasi-definite matrices.

## A basic example

```julia
using LinearAlgebra
n = 10
A0 = rand(n, n)
A = A0 * A0' + I # A is symmetric positive definite
b = rand(n)
```

```plaintext
10-element Vector{Float64}:
 0.6671734190207507
 0.8795201245464112
 0.4014423623049198
 0.7013986193829338
 0.5240562112286411
 0.3501640767940216
 0.7103439463997043
 0.8387240072315907
 0.7643879043437578
 0.6091978204000531
```





We solve the system $A x = b$ using LDLFactorizations.jl:

```julia
using LDLFactorizations
Au = Symmetric(triu(A), :U) # get upper triangle and apply Symmetric wrapper
LDL = ldl(Au)
x = LDL \ b
```

```plaintext
10-element Vector{Float64}:
  0.09551269170390501
  0.15851982492063246
 -0.06772460771870924
  0.04702474640767033
 -0.08737623048322303
 -0.10000453710268123
  0.024378568864079336
  0.17774613761343364
  0.0800033515044181
 -0.07753819241015496
```





## A more performance-focused example

We build a problem with sparse arrays.

```julia
using SparseArrays
n = 100
# create create a SQD matrix A:
A0 = sprand(Float64, n, n, 0.1)
A1 = A0 * A0' + I
A = [A1   A0;
     A0' -A1]
b = rand(2 * n)
```

```plaintext
200-element Vector{Float64}:
 0.7055033158383623
 0.04129260755941133
 0.3298541699650003
 0.9320839458363692
 0.004467125350460677
 0.216005945536193
 0.9795564937785581
 0.5039278707341872
 0.1448345516569709
 0.626477949875416
 ⋮
 0.4481909191836603
 0.3848073614164911
 0.783866960959965
 0.4543634883981226
 0.6030907151928738
 0.05331772634480436
 0.36774368546800074
 0.37623685879529534
 0.5892242926741335
```





Now if we want to use the factorization to solve multiple systems that have 
the same sparsity pattern as A, we only have to use `ldl_analyze` once.

```julia
Au = Symmetric(triu(A), :U) # get upper triangle and apply Symmetric wrapper
x = similar(b)

LDL = ldl_analyze(Au) # symbolic analysis
ldl_factorize!(Au, LDL) # factorization
ldiv!(x, LDL, b) # solve in-place (we could use ldiv!(LDL, b) if we want to overwrite b)

Au.data.nzval .+= 1.0 # modify Au without changing the sparsity pattern
ldl_factorize!(Au, LDL) 
ldiv!(x, LDL, b)
```

```plaintext
200-element Vector{Float64}:
 -1.0552368962490055
 -3.4100097792817152
 -5.429820140525826
  0.884826391609539
  2.172035400979433
 -2.6662049058691055
  1.8113453999386557
 -2.304358969898738
  0.21656973698960194
  2.0721924139169476
  ⋮
  0.6537220721375905
 -1.8000679180359143
  0.28156979645670155
 -0.6394581574790033
 -1.4776576241465957
 -2.5326397565364833
 -2.632117017499198
  2.673451266339541
 -1.0274407717705503
```





## Dynamic Regularization

When the matrix to factorize is (nearly) singular and the factorization encounters (nearly) zero pivots, 
if we know the signs of the pivots and if they are clustered by signs (for example, the 
`n_d` first pivots are positive and the other pivots are negative before permuting), we can use:

```julia
ϵ = sqrt(eps())
Au = Symmetric(triu(A), :U)
LDL = ldl_analyze(Au)
LDL.tol = ϵ
LDL.n_d = 10
LDL.r1 = 2 * ϵ # if any of the n_d first pivots |D[i]| < ϵ, then D[i] = sign(LDL.r1) * max(abs(D[i] + LDL.r1), abs(LDL.r1))
LDL.r2 = -ϵ # if any of the n - n_d last pivots |D[i]| < ϵ, then D[i] = sign(LDL.r2) * max(abs(D[i] + LDL.r2), abs(LDL.r2))
ldl_factorize!(Au, LDL)
```

```plaintext
LDLFactorizations.LDLFactorization{Float64, Int64, Int64, Int64}(true, true, true, 200, [12, 11, 5, 5, 9, 8, 8, 9, 10, 11  …  192, 193, 194, 195, 196, 197, 198, 199, 200, -1], [43, 49, 32, 50, 82, 31,
 36, 85, 116, 118  …  9, 8, 7, 6, 5, 4, 3, 2, 1, 0], [179, 188, 200, 194, 200, 187, 198, 198, 200, 200  …  200, 200, 200, 200, 200, 200, 200, 200, 200, 200], [79, 5, 97, 69, 100, 83, 44, 89, 24, 20  …
  191, 192, 193, 194, 195, 196, 198, 199, 200, 65], [30, 31, 32, 33, 2, 34, 35, 36, 37, 38  …  191, 192, 193, 194, 195, 196, 18, 197, 198, 199], [1, 44, 93, 125, 175, 257, 288, 324, 409, 525  …  16522
, 16530, 16537, 16543, 16548, 16552, 16555, 16557, 16558, 16558], [1, 12, 18, 27, 33, 33, 40, 46, 54, 63  …  842, 843, 843, 844, 845, 845, 845, 845, 845, 845], [20, 24, 39, 44, 69, 70, 83, 84, 89, 97 
 …  179, 188, 197, 188, 188, 197, 197, 197, 197, 197], [12, 31, 32, 34, 36, 37, 40, 41, 43, 44  …  197, 198, 199, 200, 198, 199, 200, 199, 200, 200], [0.011646379229087955, 0.09165678046456699, 0.0985
8802033217398, 0.00756479953194906, 0.2886631563078884, 0.012498471844763197, 0.010225786612180633, 0.14287287005723612, 0.1143224707444981, 0.22206372618460962  …  0.05670140644457037, 0.056175895227
62923, 0.0063943813504291815, 0.06588822952091196, 0.03316073223850706, -0.0019184479883028094, 0.023185920052175877, 0.04067916861084917, -0.029168299373605978, -0.11870971945553091], [2.586728455859
1814, 2.5510187679803877, 1.9090634552855794, 3.5724185502540644, 1.8837977531581152, 2.0947193541329905, 1.7676053279117703, 4.974184446375989, 4.42046976388923, 3.705273391193621  …  -3.402300576131
893, -2.893887488342363, -3.291165942621316, -4.189796801824297, -3.9377218265660816, -4.171446372310575, -3.890599403151692, -3.3695369261947774, -1.79382132446377, 3.8320270442781297], [0.0, 0.0, 0.
0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [29, 5, 9, 33, 34, 35, 36, 37, 38, 39  …  190, 191, 192, 193, 194, 195, 196, 197, 198, 199], 2.9802322387695
312e-8, -1.4901161193847656e-8, 1.4901161193847656e-8, 10)
```

