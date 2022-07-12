@def title = "How to solve a small optimization problem with Ipopt + NLPModels"
@def showall = true
@def tags = ["solvers", "ipopt"]

\preamble{Abel S. Siqueira}



To solve an optimization problem with Ipopt, the first thing to do is define your problem.
In this example, let's assume we want to solve the following problem:

\begin{aligned}
\text{min}_x \quad & (x_1 - 1)^2 + 4 (x_2 - x_1)^2 \\
\text{s.to} \quad & x_1^2 + x_2^2 \leq 1 \\
& x_1 \leq 0.5 \\
& 0.25 \leq x_2 \leq 0.75
\end{aligned}

Since our problem is simple, ADNLPModels is a perfect choice.
It defines an model that uses automatic differentiation.
It is just a matter of passing your functions and arrays to the constructor `ADNLPModel`.

```julia
using ADNLPModels

nlp = ADNLPModel(
  x -> (x[1] - 1)^2 + 4 * (x[2] - x[1]^2), # f(x)
  [0.5; 0.5], # starting point, which can be your guess
  [-Inf; 0.25], # lower bounds on variables
  [0.5; 0.75],  # upper bounds on variables
  x -> [x[1]^2 + x[2]^2], # constraints function - must be an array
  [-Inf], # lower bounds on constraints
  [1.0]   # upper bounds on constraints
)
```

```
ADNLPModel - Model with automatic differentiation backend ADNLPModels.Forwa
rdDiffAD{ForwardDiff.GradientConfig{ForwardDiff.Tag{Main.##WeaveSandBox#291
.var"#1#3", Float64}, Float64, 2, Vector{ForwardDiff.Dual{ForwardDiff.Tag{M
ain.##WeaveSandBox#291.var"#1#3", Float64}, Float64, 2}}}}(3, 2, ForwardDif
f.GradientConfig{ForwardDiff.Tag{Main.##WeaveSandBox#291.var"#1#3", Float64
}, Float64, 2, Vector{ForwardDiff.Dual{ForwardDiff.Tag{Main.##WeaveSandBox#
291.var"#1#3", Float64}, Float64, 2}}}((Partials(1.0, 0.0), Partials(0.0, 1
.0)), ForwardDiff.Dual{ForwardDiff.Tag{Main.##WeaveSandBox#291.var"#1#3", F
loat64}, Float64, 2}[Dual{ForwardDiff.Tag{Main.##WeaveSandBox#291.var"#1#3"
, Float64}}(6.93684204041936e-310,6.93684204042094e-310,6.9368420404241e-31
0), Dual{ForwardDiff.Tag{Main.##WeaveSandBox#291.var"#1#3", Float64}}(6.936
8420404257e-310,6.93684204046046e-310,6.93684204046837e-310)]))
  Problem name: Generic
   All variables: ████████████████████ 2      All constraints: ████████████
████████ 1     
            free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           upper: ██████████⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 1                upper: ████████████
████████ 1     
         low/upp: ██████████⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 1              low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
          infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: (  0.00% sparsity)   3               linear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                    nonlinear: ████████████
████████ 1     
                                                         nnzj: (  0.00% spa
rsity)   2     

  Counters:
             obj: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 grad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0                 cons: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
        cons_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0             cons_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0                 jcon: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           jgrad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                  jac: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0              jac_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         jac_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                jprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0            jprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
       jprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               jtprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0           jtprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
      jtprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                 hess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0                hprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           jhess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               jhprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0
```





Now, just pass your problem to ipopt.

```julia
using NLPModelsIpopt

output = ipopt(nlp)
```

```
***************************************************************************
***
This program contains Ipopt, a library for large-scale nonlinear optimizati
on.
 Ipopt is released as open source code under the Eclipse Public License (EP
L).
         For more information visit https://github.com/coin-or/Ipopt
***************************************************************************
***

This is Ipopt version 3.13.4, running with linear solver mumps.
NOTE: Other linear solvers might be more efficient (see Ipopt documentation
).

Number of nonzeros in equality constraint Jacobian...:        0
Number of nonzeros in inequality constraint Jacobian.:        2
Number of nonzeros in Lagrangian Hessian.............:        3

Total number of variables............................:        2
                     variables with only lower bounds:        0
                variables with lower and upper bounds:        1
                     variables with only upper bounds:        1
Total number of equality constraints.................:        0
Total number of inequality constraints...............:        1
        inequality constraints with only lower bounds:        0
   inequality constraints with lower and upper bounds:        0
        inequality constraints with only upper bounds:        1

iter    objective    inf_pr   inf_du lg(mu)  ||d||  lg(rg) alpha_du alpha_p
r  ls
   0  1.2997000e+00 0.00e+00 4.29e+00  -1.0 0.00e+00    -  0.00e+00 0.00e+0
0   0
   1  4.5361290e-01 0.00e+00 2.41e+00  -1.0 4.35e-01    -  4.59e-01 6.35e-0
1f  1
   2  5.5431421e-01 0.00e+00 5.91e-02  -1.0 1.22e-01    -  1.00e+00 1.00e+0
0f  1
   3  3.0224698e-01 0.00e+00 1.58e-02  -1.7 5.64e-02    -  1.00e+00 1.00e+0
0f  1
   4  2.5558473e-01 0.00e+00 2.94e-04  -2.5 7.49e-03    -  1.00e+00 1.00e+0
0h  1
   5  2.5030180e-01 0.00e+00 5.43e-06  -3.8 6.84e-04    -  1.00e+00 1.00e+0
0h  1
   6  2.5000360e-01 0.00e+00 1.67e-08  -5.7 3.83e-05    -  1.00e+00 1.00e+0
0h  1
   7  2.4999992e-01 0.00e+00 2.49e-12  -8.6 4.64e-07    -  1.00e+00 1.00e+0
0h  1

Number of Iterations....: 7

                                   (scaled)                 (unscaled)
Objective...............:   2.4999991501233096e-01    2.4999991501233096e-0
1
Dual infeasibility......:   2.4923148672798348e-12    2.4923148672798348e-1
2
Constraint violation....:   0.0000000000000000e+00    0.0000000000000000e+0
0
Complementarity.........:   2.5082196362733705e-09    2.5082196362733705e-0
9
Overall NLP error.......:   2.5082196362733705e-09    2.5082196362733705e-0
9


Number of objective function evaluations             = 8
Number of objective gradient evaluations             = 8
Number of equality constraint evaluations            = 0
Number of inequality constraint evaluations          = 8
Number of equality constraint Jacobian evaluations   = 0
Number of inequality constraint Jacobian evaluations = 8
Number of Lagrangian Hessian evaluations             = 7
Total CPU secs in IPOPT (w/o function evaluations)   =      3.558
Total CPU secs in NLP function evaluations           =      1.455

EXIT: Optimal Solution Found.
"Execution stats: first-order stationary"
```





To remove the output, use print_level

```julia
output = ipopt(nlp, print_level=0)
```

```
"Execution stats: first-order stationary"
```





The `output` variable containt essential information about the solution.
They can be access with `.`.

```julia
print(output)
```

```
Generic Execution stats
  status: first-order stationary
  objective value: 0.24999991501233096
  primal feasibility: 0.0
  dual feasibility: 2.4923148672798348e-12
  solution: [0.5  0.25]
  multipliers: [3.6454575515314157e-9]
  multipliers_L: [0.0  4.000000006828642]
  multipliers_U: [5.000000053347668  5.0084053323090786e-9]
  iterations: 7
  elapsed time: 0.005
  solver specific:
    real_time: 0.005313873291015625
    internal_msg: :Solve_Succeeded
```



```julia
x = output.solution
println("Solution: $x")
```

```
Solution: [0.5, 0.25]
```





That's it. If your model is more complex, you should look into NLPModelsJuMP.jl.
On the other hand, if you need more control and want to input your model manually, look for the specific how-to.


