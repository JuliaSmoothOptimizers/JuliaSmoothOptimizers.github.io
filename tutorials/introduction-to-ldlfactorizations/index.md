@def title = "LDLFactorizations tutorial"
@def showall = true
@def tags = ["linear", "factorization", "ldlt"]

\preamble{Geoffroy Leconte}



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
 0.2199496609874141
 0.2558576837746793
 0.18868944670452137
 0.2778551234931188
 0.07707074197586383
 0.17904686028389016
 0.36899590645273006
 0.7857682203755503
 0.31464057065647755
 0.09126255803152605
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
  0.1433782302037066
 -0.11115631206757776
 -0.05160108256727902
  0.04660734729933263
 -0.0966736853543695
 -0.1522011814376024
  0.15871682912356644
  0.3147603186503613
  0.08336090934701658
 -0.08523586796815098
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
 0.018036009774698325
 0.5398664639871656
 0.6559319110505696
 0.09506338363107825
 0.6088888570429802
 0.5557635247050146
 0.9024760111331119
 0.052894160397164325
 0.49170829628841106
 0.19032709192098285
 ⋮
 0.35873296394929366
 0.7600721750145916
 0.11638621822443496
 0.045954370132024525
 0.744969381509345
 0.9966621908024403
 0.5242779038745079
 0.17968352435297186
 0.8335257973269945
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
  0.23535272978954785
  0.2179229242215226
 -0.2063513514412673
 -0.33677379180889666
  0.09261589480939869
  0.3952228048610541
 -0.3548946777791512
 -0.019118254673167023
  0.15362277118078516
 -0.44145767245317835
  ⋮
  0.43058469535446986
  0.09555557113145674
  0.18957791313643813
  0.16593366370325835
  0.37128663189216365
 -0.12824563280766044
  0.3548749885782043
 -0.17424408477470915
  0.019059161804361832
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
LDLFactorizations.LDLFactorization{Float64, Int64, Int64, Int64}(true, true
, true, 200, [3, 3, 28, 13, 13, 7, 12, 11, 10, 11  …  192, 193, 194, 195, 1
96, 197, 198, 199, 200, -1], [44, 49, 93, 49, 48, 43, 81, 54, 47, 66  …  9,
 8, 7, 6, 5, 4, 3, 2, 1, 0], [200, 200, 200, 200, 200, 177, 200, 200, 200, 
200  …  200, 200, 200, 200, 200, 200, 200, 200, 200, 200], [73, 21, 85, 27,
 50, 35, 44, 29, 87, 64  …  191, 192, 193, 194, 195, 197, 198, 199, 200, 68
], [28, 29, 30, 31, 32, 33, 34, 35, 36, 37  …  191, 192, 193, 194, 195, 19,
 196, 197, 198, 199], [1, 45, 94, 187, 236, 284, 327, 408, 462, 509  …  170
37, 17045, 17052, 17058, 17063, 17067, 17070, 17072, 17073, 17073], [1, 11,
 21, 28, 36, 44, 53, 62, 72, 79  …  844, 844, 845, 845, 845, 845, 845, 845,
 845, 845], [13, 27, 44, 50, 73, 85, 87, 90, 103, 135  …  190, 189, 196, 18
9, 190, 189, 190, 190, 196, 196], [3, 28, 29, 32, 36, 37, 40, 48, 50, 52  …
  197, 198, 199, 200, 198, 199, 200, 199, 200, 200], [0.2796130469228716, 0
.27597253659270155, 0.09945201960485017, 0.10373653215169179, 0.21295374495
346567, 0.08618561152842655, 0.20653653171111272, 0.1898319627253, 0.252439
986327409, 0.031030191150581334  …  -0.07470755876636066, 0.019339997520794
527, -0.02457430757782533, -0.00504860982376947, -0.09545146596095427, 0.09
61117005738912, 0.031165508298752094, 0.17088697082470788, -0.0034617169680
76957, -0.015829448681697878], [3.2390330130579787, 3.3767026278997596, 3.5
45455627718234, 3.676578940795773, 3.257271728312239, 2.6449044706501086, 3
.4750762453355404, 2.271572689514495, 3.548406032027697, 2.4737061992409517
  …  -2.680567666546156, -3.353460396294274, -4.254692408407529, -3.9293565
43811993, -2.924361271433668, -4.433833691804344, -3.3125063989711245, -3.5
378604087448795, -3.208275403582796, 3.044229235670291], [0.0, 0.0, 0.0, 0.
0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0  …  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
 0.0, 0.0], [27, 3, 13, 31, 32, 33, 34, 35, 36, 37  …  190, 191, 192, 193, 
194, 195, 196, 197, 198, 199], 2.9802322387695312e-8, -1.4901161193847656e-
8, 1.4901161193847656e-8, 10)
```


