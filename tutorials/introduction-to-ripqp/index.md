@def title = "Introduction to RipQP"
@def showall = true
@def tags = ["introduction", "quadratic", "regularized", "solver"]

\preamble{Geoffroy Leconte}


![JSON 0.21.4](https://img.shields.io/badge/JSON-0.21.4-000?style=flat-square&labelColor=999)
![MatrixMarket 0.3.1](https://img.shields.io/badge/MatrixMarket-0.3.1-000?style=flat-square&labelColor=999)
[![RipQP 0.6.3](https://img.shields.io/badge/RipQP-0.6.3-006400?style=flat-square&labelColor=389826)](https://jso.dev/RipQP.jl/stable/)
![DelimitedFiles 1.9.1](https://img.shields.io/badge/DelimitedFiles-1.9.1-000?style=flat-square&labelColor=999)
[![QuadraticModels 0.9.5](https://img.shields.io/badge/QuadraticModels-0.9.5-8b0000?style=flat-square&labelColor=cb3c33)](https://jso.dev/QuadraticModels.jl/stable/)
[![SparseMatricesCOO 0.2.2](https://img.shields.io/badge/SparseMatricesCOO-0.2.2-4b0082?style=flat-square&labelColor=9558b2)](https://jso.dev/SparseMatricesCOO.jl/stable/)
![Plots 1.39.0](https://img.shields.io/badge/Plots-1.39.0-000?style=flat-square&labelColor=999)
[![QPSReader 0.2.1](https://img.shields.io/badge/QPSReader-0.2.1-8b0000?style=flat-square&labelColor=cb3c33)](https://jso.dev/QPSReader.jl/stable/)
[![LDLFactorizations 0.10.1](https://img.shields.io/badge/LDLFactorizations-0.10.1-4b0082?style=flat-square&labelColor=9558b2)](https://jso.dev/LDLFactorizations.jl/stable/)
![TimerOutputs 0.5.23](https://img.shields.io/badge/TimerOutputs-0.5.23-000?style=flat-square&labelColor=999)



## Input

RipQP uses the package [QuadraticModels.jl](https://github.com/JuliaSmoothOptimizers/QuadraticModels.jl) to model
convex quadratic problems.

Here is a basic example:

```julia
using QuadraticModels, LinearAlgebra, SparseMatricesCOO
Q = [6. 2. 1.
     2. 5. 2.
     1. 2. 4.]
c = [-8.; -3; -3]
A = [1. 0. 1.
     0. 2. 1.]
b = [0.; 3]
l = [-1.0;0;0]
u = [Inf; Inf; Inf]
QM = QuadraticModel(
  c,
  SparseMatrixCOO(tril(Q)),
  A=SparseMatrixCOO(A),
  lcon=b,
  ucon=b,
  lvar=l,
  uvar=u,
  c0=0.,
  name="QM"
)
```

```plaintext
QuadraticModels.QuadraticModel{Float64, Vector{Float64}, SparseMatricesCOO.SparseMatrixCOO{Float64, Int64}, SparseMatricesCOO.SparseMatrixCOO{Float64, Int64}}
  Problem name: QM
   All variables: ████████████████████ 3      All constraints: ████████████████████ 2     
            free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           lower: ████████████████████ 3                lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0              low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                fixed: ████████████████████ 2     
          infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: (  0.00% sparsity)   6               linear: ████████████████████ 2     
                                                    nonlinear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                         nnzj: ( 33.33% sparsity)   4     

  Counters:
             obj: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 grad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 cons: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
        cons_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0             cons_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 jcon: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           jgrad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                  jac: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0              jac_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         jac_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                jprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0            jprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
       jprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               jtprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0           jtprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
      jtprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 hess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                hprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           jhess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               jhprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0
```





Once your `QuadraticModel` is loaded, you can simply solve it RipQP:

```julia
using RipQP
stats = ripqp(QM)
println(stats)
```

```plaintext
Generic Execution stats
  status: first-order stationary
  objective value: 1.1250000001819647
  primal feasibility: 5.253818735984856e-13
  dual feasibility: 4.5240388878182354e-11
  solution: [-6.602556960437742e-11  1.499999999967075  6.550018773077893e-11]
  multipliers: [-5.000000000443094  2.249999999907261]
  multipliers_L: [1.3498983056074131e-12  9.350004367856938e-13  2.7500000006802963]
  multipliers_U: [0.0  0.0  0.0]
  iterations: 5
  elapsed time: 7.794533014297485
  solver specific:
    iters_sp: 5
    pdd: 1.002449365261327e-10
    psoperations: ∅
    iters_sp3: 0
    iters_sp2: 0
    relative_iter_cnt: 20
```





The `stats` output is a
[GenericExecutionStats](https://jso.dev/SolverCore.jl/dev/reference/#SolverCore.GenericExecutionStats).

It is also possible to use the package [QPSReader.jl](https://github.com/JuliaSmoothOptimizers/QPSReader.jl) in order to
read convex quadratic problems in MPS or SIF formats: (download [QAFIRO](https://raw.githubusercontent.com/JuliaSmoothOptimizers/RipQP.jl/main/test/QAFIRO.SIF))

```julia
using QPSReader, QuadraticModels
QM = QuadraticModel(readqps("assets/QAFIRO.SIF"))
```

```plaintext
QuadraticModels.QuadraticModel{Float64, Vector{Float64}, SparseMatricesCOO.SparseMatrixCOO{Float64, Int64}, SparseMatricesCOO.SparseMatrixCOO{Float64, Int64}}
  Problem name: Generic
   All variables: ████████████████████ 32     All constraints: ████████████████████ 27    
            free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           lower: ████████████████████ 32               lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                upper: ███████████████⋅⋅⋅⋅⋅ 19    
         low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0              low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                fixed: ██████⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 8     
          infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: ( 98.86% sparsity)   6               linear: ████████████████████ 27    
                                                    nonlinear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                         nnzj: ( 90.39% sparsity)   83    

  Counters:
             obj: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 grad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 cons: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
        cons_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0             cons_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 jcon: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           jgrad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                  jac: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0              jac_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         jac_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                jprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0            jprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
       jprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               jtprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0           jtprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
      jtprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 hess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                hprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           jhess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               jhprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0
```





## Logging

RipQP displays some logs at each iterate.

```julia
stats = ripqp(QM)
```

```plaintext
"Execution stats: first-order stationary"
```





You can deactivate logging with

```julia
stats = ripqp(QM, display = false)
```

```plaintext
"Execution stats: first-order stationary"
```





It is also possible to get a history of several quantities such as the primal and dual residuals and the relative primal-dual gap. These quantites are available in the dictionary `solver_specific` of the `stats`.

```julia
stats = ripqp(QM, history = true)
pddH = stats.solver_specific[:pddH];
```




## Change configuration and tolerances

You can use `RipQP` without scaling with:

```julia
stats = ripqp(QM, scaling = false)
```

```plaintext
"Execution stats: first-order stationary"
```





You can also change the [`RipQP.InputTol`](https://jso.dev/RipQP.jl/stable/API/#RipQP.InputTol) type to change the tolerances for the stopping criteria:

```julia
stats = ripqp(QM, itol = InputTol(max_iter = 100, ϵ_rb = 1e-4), scaling = false)
```

```plaintext
"Execution stats: first-order stationary"
```





## Save the Interior-Point system

At every iteration, RipQP solves two linear systems with the default Predictor-Corrector method (the affine system and the corrector-centering system), or one linear system with the Infeasible Path-Following method.

To save these systems, you can use:

```julia
w = SystemWrite(write = true, name="test_", kfirst = 4, kgap=3)
stats1 = ripqp(QM, w = w)
```

```plaintext
"Execution stats: first-order stationary"
```





This will save one matrix and the associated two right hand sides of the PC method every three iterations starting at
iteration four.
Then, you can read the saved files with:

```julia
using DelimitedFiles, MatrixMarket
K = MatrixMarket.mmread("test_K_iter4.mtx")
rhs_aff = readdlm("test_rhs_iter4_aff.rhs", Float64)[:]
rhs_cc =  readdlm("test_rhs_iter4_cc.rhs", Float64)[:];
```




## Timers

You can see the elapsed time with:

```julia
stats1.elapsed_time
```

```plaintext
0.12202596664428711
```





For more advance timers you can use [TimerOutputs.jl](https://github.com/KristofferC/TimerOutputs.jl):

```julia
using TimerOutputs
TimerOutputs.enable_debug_timings(RipQP)
reset_timer!(RipQP.to)
stats = ripqp(QM)
TimerOutputs.complement!(RipQP.to) # print complement of timed sections
show(RipQP.to, sortby = :firstexec)
```

```plaintext
──────────────────────────────────────────────────────────────────────
                              Time                    Allocations      
                     ───────────────────────   ────────────────────────
  Tot / % measured:       259ms /   0.0%           22.6MiB /   0.0%    

 Section     ncalls     time    %tot     avg     alloc    %tot      avg
 ──────────────────────────────────────────────────────────────────────
 factorize       10   38.8μs  100.0%  3.88μs     0.00B     - %    0.00B
 ──────────────────────────────────────────────────────────────────────
```

