@def title = "LDLFactorizations tutorial"
@def showall = true
@def tags = ["linear", "factorization", "ldlt"]

\preamble{Geoffroy Leconte}


![JSON 0.21.4](https://img.shields.io/badge/JSON-0.21.4-000?style=flat-square&labelColor=999)
![MatrixMarket 0.3.1](https://img.shields.io/badge/MatrixMarket-0.3.1-000?style=flat-square&labelColor=999)
[![RipQP 0.6.2](https://img.shields.io/badge/RipQP-0.6.2-006400?style=flat-square&labelColor=389826)](https://juliasmoothoptimizers.github.io/RipQP.jl/stable/)
![DelimitedFiles 1.9.1](https://img.shields.io/badge/DelimitedFiles-1.9.1-000?style=flat-square&labelColor=999)
[![QuadraticModels 0.9.4](https://img.shields.io/badge/QuadraticModels-0.9.4-8b0000?style=flat-square&labelColor=cb3c33)](https://juliasmoothoptimizers.github.io/QuadraticModels.jl/stable/)
[![SparseMatricesCOO 0.2.1](https://img.shields.io/badge/SparseMatricesCOO-0.2.1-4b0082?style=flat-square&labelColor=9558b2)](https://juliasmoothoptimizers.github.io/SparseMatricesCOO.jl/stable/)
![Plots 1.38.15](https://img.shields.io/badge/Plots-1.38.15-000?style=flat-square&labelColor=999)
[![QPSReader 0.2.1](https://img.shields.io/badge/QPSReader-0.2.1-8b0000?style=flat-square&labelColor=cb3c33)](https://juliasmoothoptimizers.github.io/QPSReader.jl/stable/)
[![LDLFactorizations 0.10.0](https://img.shields.io/badge/LDLFactorizations-0.10.0-4b0082?style=flat-square&labelColor=9558b2)](https://juliasmoothoptimizers.github.io/LDLFactorizations.jl/stable/)
![TimerOutputs 0.5.23](https://img.shields.io/badge/TimerOutputs-0.5.23-000?style=flat-square&labelColor=999)



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
 0.3800978194205501
 0.8887149918100762
 0.4119148540790598
 0.8575310580074677
 0.25464694369857666
 0.49775951114577244
 0.5918245097052003
 0.8611890555606926
 0.9100253734497182
 0.5859061686556828
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
 -0.1104343311335546
  0.20745123758722706
 -0.1557977110049982
  0.37992870961324327
 -0.1811596702080861
 -0.1997959620533808
 -0.07490212034277446
  0.11730772110987357
  0.4001231433123401
  0.04587930799030248
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
 0.4417198807887073
 0.3432661846628027
 0.7320703520741687
 0.6111291434725621
 0.7769521892365086
 0.8758912633090524
 0.8258778473443604
 0.17824915504346772
 0.7565504770356448
 0.12856548741166207
 ⋮
 0.9710554593624576
 0.6235267124887334
 0.3070074399256624
 0.6252158923583157
 0.9941172247275837
 0.7485351883963196
 0.7777205268535066
 0.7504957175076318
 0.07081098366782557
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
 -0.5011822228259845
  0.1944097060772648
 -0.6685450637702302
  1.1960219690004545
  0.8934849125120895
 -0.4623794256403583
  0.6803197719909667
 -0.4927372875614832
  1.0206290329325753
 -0.3490906772857156
  ⋮
  0.015333759530323315
  0.02754260329561411
  0.43811775834754435
 -0.5637940254613505
  0.41312079375177185
  0.2786431472607918
  0.14806059169053012
  0.2163080922622114
  0.37144130306009476
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
LDLFactorizations.LDLFactorization{Float64, Int64, Int64, Int64}(true, true, true, 200, [3, 3, 30, 7, 6, 7, 29, 13, 13, 12  …  192, 193, 194, 195, 196, 197, 198, 199, 200, -1], [44, 59, 112, 45, 48, 8
3, 112, 42, 52, 47  …  9, 8, 7, 6, 5, 4, 3, 2, 1, 0], [200, 178, 200, 199, 191, 200, 200, 199, 200, 200  …  200, 200, 200, 200, 200, 200, 200, 200, 200, 200], [102, 45, 41, 101, 128, 153, 131, 191, 19
7, 141  …  189, 190, 193, 194, 195, 196, 198, 199, 200, 105], [14, 17, 29, 30, 31, 32, 33, 34, 35, 36  …  8, 11, 193, 194, 195, 196, 9, 197, 198, 199], [1, 45, 104, 216, 261, 309, 392, 504, 546, 598  
…  16956, 16964, 16971, 16977, 16982, 16986, 16989, 16991, 16992, 16992], [1, 1, 1, 8, 16, 30, 40, 54, 61, 73  …  865, 865, 866, 867, 868, 868, 868, 868, 868, 868], [14, 51, 53, 72, 84, 97, 101, 14, 3
7, 45  …  192, 191, 192, 192, 191, 192, 197, 197, 197, 197], [3, 38, 73, 74, 77, 79, 101, 112, 113, 115  …  197, 198, 199, 200, 198, 199, 200, 199, 200, 200], [-0.12870838593028208, -0.076336797495596
96, -0.3432985545153559, -0.25019229498027584, -0.2810592343391254, -0.33662043771632044, -0.37121521169132954, 0.061111773599277525, 0.10691375981261944, 0.015533160073056617  …  -0.07319133013654525
, 0.01601877289410038, -0.07673258096548838, 0.0636956656756199, 0.05768277676736338, -0.0567709564391419, -0.03454099464171037, -0.05020196684672451, 0.06649663391958432, -0.016811402167141474], [-2.
0508789121282875, 3.134502749255222, 4.1137747336777455, -1.7979665244334286, -3.2593679811098095, -3.2821641005759274, -3.0103996493209797, -1.883197558352447, -3.174420416799561, -4.238353932857187 
 …  -4.733153589487681, -2.585862186572218, -2.653380915604213, -3.0221397044658334, -3.083210976421225, -3.3430215070150426, -4.238274245624685, -3.724802010497127, -3.097713740900073, -5.41301511033
3084], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [9, 7, 29, 30, 31, 32, 33, 34, 35, 36  …  190, 191, 192, 193, 194, 195, 196, 197, 198, 1
99], 2.9802322387695312e-8, -1.4901161193847656e-8, 1.4901161193847656e-8, 10)
```





## Choosing the precision of the factorization

It is possible to factorize a matrix in a different type than the type of its elements:

```julia
# with eltype(Au) == Float64
LDL64 = ldl(Au) # factorization in eltype(Au) = Float64
LDL32 = ldl(Au, Float32) # factorization in Float32
```

```plaintext
LDLFactorizations.LDLFactorization{Float32, Int64, Int64, Int64}(true, true, true, 200, [3, 3, 30, 7, 6, 7, 29, 13, 13, 12  …  192, 193, 194, 195, 196, 197, 198, 199, 200, -1], [44, 59, 112, 45, 48, 8
3, 112, 42, 52, 47  …  9, 8, 7, 6, 5, 4, 3, 2, 1, 0], [200, 178, 200, 199, 191, 200, 200, 199, 200, 200  …  200, 200, 200, 200, 200, 200, 200, 200, 200, 200], [102, 45, 41, 101, 128, 153, 131, 191, 19
7, 141  …  189, 190, 193, 194, 195, 196, 198, 199, 200, 105], [14, 17, 29, 30, 31, 32, 33, 34, 35, 36  …  8, 11, 193, 194, 195, 196, 9, 197, 198, 199], [1, 45, 104, 216, 261, 309, 392, 504, 546, 598  
…  16956, 16964, 16971, 16977, 16982, 16986, 16989, 16991, 16992, 16992], [1, 1, 1, 8, 16, 30, 40, 54, 61, 73  …  865, 865, 866, 867, 868, 868, 868, 868, 868, 868], [14, 51, 53, 72, 84, 97, 101, 14, 3
7, 45  …  192, 191, 192, 192, 191, 192, 197, 197, 197, 197], [3, 38, 73, 74, 77, 79, 101, 112, 113, 115  …  197, 198, 199, 200, 198, 199, 200, 199, 200, 200], Float32[-0.12870838, -0.07633679, -0.3432
9855, -0.25019228, -0.28105924, -0.33662042, -0.3712152, 0.06111177, 0.10691375, 0.0155331595  …  -0.07319134, 0.016018782, -0.076732576, 0.06369566, 0.057682775, -0.05677097, -0.034540914, -0.0502019
3, 0.06649658, -0.016811408], Float32[-2.050879, 3.1345026, 4.113775, -1.7979665, -3.259368, -3.282164, -3.0103996, -1.8831975, -3.1744204, -4.2383537  …  -4.733151, -2.5858614, -2.6533794, -3.0221407
, -3.0832105, -3.3430223, -4.238274, -3.7248054, -3.0977137, -5.4130135], Float32[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [9, 7, 29, 30,
 31, 32, 33, 34, 35, 36  …  190, 191, 192, 193, 194, 195, 196, 197, 198, 199], 0.0f0, 0.0f0, 0.0f0, 200)
```



```julia
# with eltype(Au) == Float64
LDL64 = ldl_analyze(Au) # symbolic analysis in eltype(Au) = Float64
LDL32 = ldl_analyze(Au, Float32) # symbolic analysis in Float32
ldl_factorize!(Au, LDL64)
ldl_factorize!(Au, LDL32)
```

```plaintext
LDLFactorizations.LDLFactorization{Float32, Int64, Int64, Int64}(true, true, true, 200, [3, 3, 30, 7, 6, 7, 29, 13, 13, 12  …  192, 193, 194, 195, 196, 197, 198, 199, 200, -1], [44, 59, 112, 45, 48, 8
3, 112, 42, 52, 47  …  9, 8, 7, 6, 5, 4, 3, 2, 1, 0], [200, 178, 200, 199, 191, 200, 200, 199, 200, 200  …  200, 200, 200, 200, 200, 200, 200, 200, 200, 200], [102, 45, 41, 101, 128, 153, 131, 191, 19
7, 141  …  189, 190, 193, 194, 195, 196, 198, 199, 200, 105], [14, 17, 29, 30, 31, 32, 33, 34, 35, 36  …  8, 11, 193, 194, 195, 196, 9, 197, 198, 199], [1, 45, 104, 216, 261, 309, 392, 504, 546, 598  
…  16956, 16964, 16971, 16977, 16982, 16986, 16989, 16991, 16992, 16992], [1, 1, 1, 8, 16, 30, 40, 54, 61, 73  …  865, 865, 866, 867, 868, 868, 868, 868, 868, 868], [14, 51, 53, 72, 84, 97, 101, 14, 3
7, 45  …  192, 191, 192, 192, 191, 192, 197, 197, 197, 197], [3, 38, 73, 74, 77, 79, 101, 112, 113, 115  …  197, 198, 199, 200, 198, 199, 200, 199, 200, 200], Float32[-0.12870838, -0.07633679, -0.3432
9855, -0.25019228, -0.28105924, -0.33662042, -0.3712152, 0.06111177, 0.10691375, 0.0155331595  …  -0.07319134, 0.016018782, -0.076732576, 0.06369566, 0.057682775, -0.05677097, -0.034540914, -0.0502019
3, 0.06649658, -0.016811408], Float32[-2.050879, 3.1345026, 4.113775, -1.7979665, -3.259368, -3.282164, -3.0103996, -1.8831975, -3.1744204, -4.2383537  …  -4.733151, -2.5858614, -2.6533794, -3.0221407
, -3.0832105, -3.3430223, -4.238274, -3.7248054, -3.0977137, -5.4130135], Float32[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [9, 7, 29, 30,
 31, 32, 33, 34, 35, 36  …  190, 191, 192, 193, 194, 195, 196, 197, 198, 199], 0.0f0, 0.0f0, 0.0f0, 200)
```

