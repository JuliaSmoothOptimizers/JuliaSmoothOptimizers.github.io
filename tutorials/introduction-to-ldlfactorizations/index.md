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
 0.6688819199489577
 0.4459766439920064
 0.28089658277569474
 0.18117168304923803
 0.16392940115784527
 0.3003017691230533
 0.5872409466772568
 0.7206250357141736
 0.5421275129306117
 0.8360615231864569
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
  0.08462494846599132
  0.01185850696356787
 -0.10408084533061276
 -0.06324615932629167
 -0.1524437171940213
 -0.1160215504212729
  0.1077676540896556
  0.11792140252370092
  0.11138600164314427
  0.19715529651511712
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
 0.5975459776769299
 0.8352644120109513
 0.6687753180594733
 0.47383777869123667
 0.00739765020057126
 0.36938284388226617
 0.4302341473232568
 0.11636704908192896
 0.705776623250129
 0.39297937967272445
 ⋮
 0.439004628752386
 0.7071991423835232
 0.9456396463103999
 0.5258641746873676
 0.08494616642675668
 0.3423423217463435
 0.7936413113614876
 0.22707396271673896
 0.7390643352674899
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
 -0.838255108850801
  0.9844551262413594
  1.3457117734905968
  0.46319694578304144
 -0.03373720238678292
  0.33042208208779755
  0.8111740951572513
  0.1383796178198761
  1.1168705320783638
  0.06761872781188222
  ⋮
 -0.011752422565167338
  0.6217106277367016
 -0.2682114952545201
 -0.46971602925471023
 -0.04296912192077891
 -0.35150853439158725
 -0.053757673444703453
  0.6235757811999934
  0.328446368617437
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
LDLFactorizations.LDLFactorization{Float64, Int64, Int64, Int64}(true, true, true, 200, [7, 3, 6, 5, 6, 7, 28, 9, 29, 13  …  192, 193, 194, 195, 196, 197, 198, 199, 200, -1], [42, 56, 79, 46, 85, 123,
 138, 45, 80, 43  …  9, 8, 7, 6, 5, 4, 3, 2, 1, 0], [200, 198, 198, 197, 197, 198, 200, 188, 193, 200  …  200, 200, 200, 200, 200, 200, 200, 200, 200, 200], [135, 150, 136, 198, 126, 121, 134, 61, 161
, 146  …  191, 192, 193, 194, 195, 196, 197, 199, 200, 178], [28, 29, 30, 31, 32, 33, 23, 34, 35, 36  …  191, 192, 193, 194, 195, 196, 197, 4, 198, 199], [1, 43, 99, 178, 224, 309, 432, 570, 615, 695 
 …  16930, 16938, 16945, 16951, 16956, 16960, 16963, 16965, 16966, 16966], [1, 8, 18, 29, 36, 43, 55, 59, 65, 74  …  718, 718, 718, 719, 719, 720, 721, 721, 721, 721], [7, 26, 100, 121, 140, 160, 198,
 7, 18, 25  …  198, 186, 198, 198, 198, 198, 198, 198, 198, 198], [7, 42, 49, 50, 52, 58, 66, 71, 89, 99  …  197, 198, 199, 200, 198, 199, 200, 199, 200, 200], [0.11784971932388709, -0.428687566092606
05, -0.15998593060833619, -0.38427120404270776, -0.19698131349283157, -0.02173905043449283, -0.2670585285678956, -0.16675258367613532, -0.002221485136222353, -0.26288362007264016  …  -0.01615035530264
627, 0.11975590813547811, 0.01190274493843231, 0.1023087554001942, -0.04229122159932543, -0.01861081358567269, 0.008676024758162072, -0.027544190328328097, -0.04695557653767509, 0.008298621043134672],
 [-1.9211475697955844, -3.282380425518946, -3.048593736662529, -3.9512821172650656, -1.9328061389736357, -4.3081542223512646, -2.8410706897655498, 3.175494480623696, -3.269111642940909, -2.77397193661
36217  …  -2.9651628899911167, -4.6143530357562925, -2.587608849329615, -3.8336119471160788, -3.663803103291368, -2.3902445403618264, -2.718884384604339, -2.723896066078389, -3.4511956270671575, -3.12
1945846571149], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [10, 13, 27, 28, 29, 30, 31, 32, 33, 34  …  190, 191, 192, 193, 194, 195, 196, 
197, 198, 199], 2.9802322387695312e-8, -1.4901161193847656e-8, 1.4901161193847656e-8, 10)
```





## Choosing the precision of the factorization

It is possible to factorize a matrix in a different type than the type of its elements:

```julia
# with eltype(Au) == Float64
LDL64 = ldl(Au) # factorization in eltype(Au) = Float64
LDL32 = ldl(Au, Float32) # factorization in Float32
```

```plaintext
LDLFactorizations.LDLFactorization{Float32, Int64, Int64, Int64}(true, true, true, 200, [7, 3, 6, 5, 6, 7, 28, 9, 29, 13  …  192, 193, 194, 195, 196, 197, 198, 199, 200, -1], [42, 56, 79, 46, 85, 123,
 138, 45, 80, 43  …  9, 8, 7, 6, 5, 4, 3, 2, 1, 0], [200, 198, 198, 197, 197, 198, 200, 188, 193, 200  …  200, 200, 200, 200, 200, 200, 200, 200, 200, 200], [135, 150, 136, 198, 126, 121, 134, 61, 161
, 146  …  191, 192, 193, 194, 195, 196, 197, 199, 200, 178], [28, 29, 30, 31, 32, 33, 23, 34, 35, 36  …  191, 192, 193, 194, 195, 196, 197, 4, 198, 199], [1, 43, 99, 178, 224, 309, 432, 570, 615, 695 
 …  16930, 16938, 16945, 16951, 16956, 16960, 16963, 16965, 16966, 16966], [1, 8, 18, 29, 36, 43, 55, 59, 65, 74  …  718, 718, 718, 719, 719, 720, 721, 721, 721, 721], [7, 26, 100, 121, 140, 160, 198,
 7, 18, 25  …  198, 186, 198, 198, 198, 198, 198, 198, 198, 198], [7, 42, 49, 50, 52, 58, 66, 71, 89, 99  …  197, 198, 199, 200, 198, 199, 200, 199, 200, 200], Float32[0.11784972, -0.42868757, -0.1599
8593, -0.3842712, -0.19698131, -0.02173905, -0.26705852, -0.16675258, -0.0022214851, -0.2628836  …  -0.01615033, 0.1197559, 0.011902741, 0.102308795, -0.042291276, -0.018610822, 0.008676029, -0.027544
128, -0.046955522, 0.008298557], Float32[-1.9211476, -3.2823803, -3.0485935, -3.951282, -1.9328061, -4.3081546, -2.841071, 3.1754944, -3.2691116, -2.773972  …  -2.9651628, -4.6143546, -2.5876086, -3.8
336098, -3.6638026, -2.3902442, -2.7188828, -2.7238998, -3.4511974, -3.1219478], Float32[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [10, 13
, 27, 28, 29, 30, 31, 32, 33, 34  …  190, 191, 192, 193, 194, 195, 196, 197, 198, 199], 0.0f0, 0.0f0, 0.0f0, 200)
```



```julia
# with eltype(Au) == Float64
LDL64 = ldl_analyze(Au) # symbolic analysis in eltype(Au) = Float64
LDL32 = ldl_analyze(Au, Float32) # symbolic analysis in Float32
ldl_factorize!(Au, LDL64)
ldl_factorize!(Au, LDL32)
```

```plaintext
LDLFactorizations.LDLFactorization{Float32, Int64, Int64, Int64}(true, true, true, 200, [7, 3, 6, 5, 6, 7, 28, 9, 29, 13  …  192, 193, 194, 195, 196, 197, 198, 199, 200, -1], [42, 56, 79, 46, 85, 123,
 138, 45, 80, 43  …  9, 8, 7, 6, 5, 4, 3, 2, 1, 0], [200, 198, 198, 197, 197, 198, 200, 188, 193, 200  …  200, 200, 200, 200, 200, 200, 200, 200, 200, 200], [135, 150, 136, 198, 126, 121, 134, 61, 161
, 146  …  191, 192, 193, 194, 195, 196, 197, 199, 200, 178], [28, 29, 30, 31, 32, 33, 23, 34, 35, 36  …  191, 192, 193, 194, 195, 196, 197, 4, 198, 199], [1, 43, 99, 178, 224, 309, 432, 570, 615, 695 
 …  16930, 16938, 16945, 16951, 16956, 16960, 16963, 16965, 16966, 16966], [1, 8, 18, 29, 36, 43, 55, 59, 65, 74  …  718, 718, 718, 719, 719, 720, 721, 721, 721, 721], [7, 26, 100, 121, 140, 160, 198,
 7, 18, 25  …  198, 186, 198, 198, 198, 198, 198, 198, 198, 198], [7, 42, 49, 50, 52, 58, 66, 71, 89, 99  …  197, 198, 199, 200, 198, 199, 200, 199, 200, 200], Float32[0.11784972, -0.42868757, -0.1599
8593, -0.3842712, -0.19698131, -0.02173905, -0.26705852, -0.16675258, -0.0022214851, -0.2628836  …  -0.01615033, 0.1197559, 0.011902741, 0.102308795, -0.042291276, -0.018610822, 0.008676029, -0.027544
128, -0.046955522, 0.008298557], Float32[-1.9211476, -3.2823803, -3.0485935, -3.951282, -1.9328061, -4.3081546, -2.841071, 3.1754944, -3.2691116, -2.773972  …  -2.9651628, -4.6143546, -2.5876086, -3.8
336098, -3.6638026, -2.3902442, -2.7188828, -2.7238998, -3.4511974, -3.1219478], Float32[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [10, 13
, 27, 28, 29, 30, 31, 32, 33, 34  …  190, 191, 192, 193, 194, 195, 196, 197, 198, 199], 0.0f0, 0.0f0, 0.0f0, 200)
```

