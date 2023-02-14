@def title = "LDLFactorizations tutorial"
@def showall = true
@def tags = ["linear", "factorization", "ldlt"]

\preamble{Geoffroy Leconte}


![JSON 0.21.3](https://img.shields.io/badge/JSON-0.21.3-000?style=flat-square&labelColor=999)
![MatrixMarket 0.3.1](https://img.shields.io/badge/MatrixMarket-0.3.1-000?style=flat-square&labelColor=999)
[![RipQP 0.6.1](https://img.shields.io/badge/RipQP-0.6.1-006400?style=flat-square&labelColor=389826)](https://juliasmoothoptimizers.github.io/RipQP.jl/stable/)
[![SparseMatricesCOO 0.2.1](https://img.shields.io/badge/SparseMatricesCOO-0.2.1-4b0082?style=flat-square&labelColor=9558b2)](https://juliasmoothoptimizers.github.io/SparseMatricesCOO.jl/stable/)
[![QuadraticModels 0.9.3](https://img.shields.io/badge/QuadraticModels-0.9.3-8b0000?style=flat-square&labelColor=cb3c33)](https://juliasmoothoptimizers.github.io/QuadraticModels.jl/stable/)
![Plots 1.38.5](https://img.shields.io/badge/Plots-1.38.5-000?style=flat-square&labelColor=999)
[![QPSReader 0.2.1](https://img.shields.io/badge/QPSReader-0.2.1-8b0000?style=flat-square&labelColor=cb3c33)](https://juliasmoothoptimizers.github.io/QPSReader.jl/stable/)
[![LDLFactorizations 0.10.0](https://img.shields.io/badge/LDLFactorizations-0.10.0-4b0082?style=flat-square&labelColor=9558b2)](https://juliasmoothoptimizers.github.io/LDLFactorizations.jl/stable/)
![TimerOutputs 0.5.22](https://img.shields.io/badge/TimerOutputs-0.5.22-000?style=flat-square&labelColor=999)



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
 0.6637705492339632
 0.41019512862484264
 0.9172349703803852
 0.6942280649505308
 0.11930086017026187
 0.012955145994572259
 0.33225453826609463
 0.7156040596841332
 0.06328491050207596
 0.8796551888053527
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
  0.1254195808471332
 -0.10490807538756697
  0.34761584066793016
  0.25073426228500717
 -0.004201024899851545
 -0.29140237837204724
 -0.24410538550539124
  0.13004925146844606
 -0.10294793952370454
  0.33820221279257734
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
 0.011444364045761657
 0.9722675187402641
 0.10657803127883425
 0.11082278559426073
 0.05563473620449533
 0.2497620693103938
 0.3939149264383802
 0.33540004420271186
 0.6766324037244715
 0.7700567328954319
 ⋮
 0.28275668411365296
 0.8792962722228473
 0.5458655624296084
 0.881452014738909
 0.5996906550917762
 0.9368876051598314
 0.8360715546837431
 0.8223421552839791
 0.5894123108261543
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
  0.5650368679482819
 -1.538933239776177
  0.051926682083182345
  4.485644136351844
  0.8946261178055129
 -2.1980829281589007
 -0.6048022072571924
 -0.43955796723253654
 -1.9019924760805926
 -3.343472920750972
  ⋮
  0.7141307276561986
  1.1090628482689056
  0.6435346359329019
  0.9578813509565804
  0.4943325463162171
  0.7047972014637308
 -1.5686941811611481
  0.2580780931326643
 -0.08200477480074955
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
LDLFactorizations.LDLFactorization{Float64, Int64, Int64, Int64}(true, true, true, 200, [2, 3, 30, 14, 13, 8, 8, 13, 12, 11  …  192, 193, 194, 195, 196, 197, 198, 199, 200, -1], [52, 76, 88, 36, 55, 3
2, 38, 72, 48, 40  …  9, 8, 7, 6, 5, 4, 3, 2, 1, 0], [200, 200, 200, 200, 200, 174, 195, 195, 200, 193  …  200, 200, 200, 200, 200, 200, 200, 200, 200, 200], [64, 1, 9, 93, 66, 91, 22, 74, 24, 72  …  
189, 190, 193, 194, 195, 196, 198, 199, 200, 12], [2, 30, 31, 32, 33, 34, 35, 36, 3, 37  …  16, 26, 193, 194, 195, 196, 19, 197, 198, 199], [1, 53, 129, 217, 253, 308, 340, 378, 450, 498  …  16705, 16
713, 16720, 16726, 16731, 16735, 16738, 16740, 16741, 16741], [1, 2, 11, 21, 29, 37, 41, 50, 57, 58  …  801, 801, 802, 803, 803, 803, 803, 803, 803, 803], [64, 9, 34, 64, 74, 91, 93, 105, 134, 166  … 
 192, 191, 192, 197, 192, 192, 192, 197, 197, 197], [2, 3, 30, 31, 33, 35, 37, 38, 39, 45  …  197, 198, 199, 200, 198, 199, 200, 199, 200, 200], [0.04078878797650162, 0.042345334625293655, 0.003537056
1763249007, 0.02097687819826563, 0.028557654826689836, 0.04511830624222205, 0.10367991837144638, 0.19470350934179917, 0.12861191169839156, 0.023672795754998033  …  -0.0107124509317256, -0.001399720428
6910173, 0.14720675063305014, 0.0794929349743419, -0.055872801998161484, -0.043671535323809935, 0.03826304517040101, 0.2292369657881975, -0.022390902637469626, 0.09663207652866876], [2.097268438952092
, 3.407209557957926, 2.234654191521763, 1.6688848017049493, 2.3907659882809895, 2.6053509504481127, 2.2351045566725842, 1.361240987239245, 2.755690311798701, 2.6258609848763252  …  -3.732890038512228,
 -3.0803562957168853, -1.9511873440094138, -4.232792492108895, -3.9859488248351336, -3.065123712629523, -4.784191440877116, -3.1380427293767483, -3.322106125738711, 3.098282744531283], [0.0, 0.0, 0.0,
 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [29, 12, 13, 14, 32, 33, 34, 35, 36, 37  …  190, 191, 192, 193, 194, 195, 196, 197, 198, 199], 2.9802322387695
312e-8, -1.4901161193847656e-8, 1.4901161193847656e-8, 10)
```





## Choosing the precision of the factorization

It is possible to factorize a matrix in a different type than the type of its elements:

```julia
# with eltype(Au) == Float64
LDL64 = ldl(Au) # factorization in eltype(Au) = Float64
LDL32 = ldl(Au, Float32) # factorization in Float32
```

```plaintext
LDLFactorizations.LDLFactorization{Float32, Int64, Int64, Int64}(true, true, true, 200, [2, 3, 30, 14, 13, 8, 8, 13, 12, 11  …  192, 193, 194, 195, 196, 197, 198, 199, 200, -1], [52, 76, 88, 36, 55, 3
2, 38, 72, 48, 40  …  9, 8, 7, 6, 5, 4, 3, 2, 1, 0], [200, 200, 200, 200, 200, 174, 195, 195, 200, 193  …  200, 200, 200, 200, 200, 200, 200, 200, 200, 200], [64, 1, 9, 93, 66, 91, 22, 74, 24, 72  …  
189, 190, 193, 194, 195, 196, 198, 199, 200, 12], [2, 30, 31, 32, 33, 34, 35, 36, 3, 37  …  16, 26, 193, 194, 195, 196, 19, 197, 198, 199], [1, 53, 129, 217, 253, 308, 340, 378, 450, 498  …  16705, 16
713, 16720, 16726, 16731, 16735, 16738, 16740, 16741, 16741], [1, 2, 11, 21, 29, 37, 41, 50, 57, 58  …  801, 801, 802, 803, 803, 803, 803, 803, 803, 803], [64, 9, 34, 64, 74, 91, 93, 105, 134, 166  … 
 192, 191, 192, 197, 192, 192, 192, 197, 197, 197], [2, 3, 30, 31, 33, 35, 37, 38, 39, 45  …  197, 198, 199, 200, 198, 199, 200, 199, 200, 200], Float32[0.040788792, 0.042345338, 0.0035370563, 0.02097
6879, 0.028557656, 0.045118306, 0.10367992, 0.19470352, 0.1286119, 0.023672797  …  -0.010712491, -0.0013997076, 0.14720662, 0.079492934, -0.05587281, -0.043671504, 0.038263045, 0.22923708, -0.02239091
1, 0.09663207], Float32[2.0972683, 3.4072096, 2.2346542, 1.6688848, 2.390766, 2.605351, 2.2351046, 1.3612409, 2.7556903, 2.625861  …  -3.7328908, -3.080356, -1.9511867, -4.2327876, -3.9859514, -3.0651
236, -4.78419, -3.1380417, -3.3221045, 3.0982828], Float32[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [29, 12, 13, 14, 32, 33, 34, 35, 36, 
37  …  190, 191, 192, 193, 194, 195, 196, 197, 198, 199], 0.0f0, 0.0f0, 0.0f0, 200)
```



```julia
# with eltype(Au) == Float64
LDL64 = ldl_analyze(Au) # symbolic analysis in eltype(Au) = Float64
LDL32 = ldl_analyze(Au, Float32) # symbolic analysis in Float32
ldl_factorize!(Au, LDL64)
ldl_factorize!(Au, LDL32)
```

```plaintext
LDLFactorizations.LDLFactorization{Float32, Int64, Int64, Int64}(true, true, true, 200, [2, 3, 30, 14, 13, 8, 8, 13, 12, 11  …  192, 193, 194, 195, 196, 197, 198, 199, 200, -1], [52, 76, 88, 36, 55, 3
2, 38, 72, 48, 40  …  9, 8, 7, 6, 5, 4, 3, 2, 1, 0], [200, 200, 200, 200, 200, 174, 195, 195, 200, 193  …  200, 200, 200, 200, 200, 200, 200, 200, 200, 200], [64, 1, 9, 93, 66, 91, 22, 74, 24, 72  …  
189, 190, 193, 194, 195, 196, 198, 199, 200, 12], [2, 30, 31, 32, 33, 34, 35, 36, 3, 37  …  16, 26, 193, 194, 195, 196, 19, 197, 198, 199], [1, 53, 129, 217, 253, 308, 340, 378, 450, 498  …  16705, 16
713, 16720, 16726, 16731, 16735, 16738, 16740, 16741, 16741], [1, 2, 11, 21, 29, 37, 41, 50, 57, 58  …  801, 801, 802, 803, 803, 803, 803, 803, 803, 803], [64, 9, 34, 64, 74, 91, 93, 105, 134, 166  … 
 192, 191, 192, 197, 192, 192, 192, 197, 197, 197], [2, 3, 30, 31, 33, 35, 37, 38, 39, 45  …  197, 198, 199, 200, 198, 199, 200, 199, 200, 200], Float32[0.040788792, 0.042345338, 0.0035370563, 0.02097
6879, 0.028557656, 0.045118306, 0.10367992, 0.19470352, 0.1286119, 0.023672797  …  -0.010712491, -0.0013997076, 0.14720662, 0.079492934, -0.05587281, -0.043671504, 0.038263045, 0.22923708, -0.02239091
1, 0.09663207], Float32[2.0972683, 3.4072096, 2.2346542, 1.6688848, 2.390766, 2.605351, 2.2351046, 1.3612409, 2.7556903, 2.625861  …  -3.7328908, -3.080356, -1.9511867, -4.2327876, -3.9859514, -3.0651
236, -4.78419, -3.1380417, -3.3221045, 3.0982828], Float32[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [29, 12, 13, 14, 32, 33, 34, 35, 36, 
37  …  190, 191, 192, 193, 194, 195, 196, 197, 198, 199], 0.0f0, 0.0f0, 0.0f0, 200)
```

