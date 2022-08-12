@def title = "OptimizationProblems.jl tutorial"
@def showall = true
@def tags = ["models", "nlpmodels", "test set", "manual"]

\preamble{Tangi Migot}



In this tutorial, we will see how to access the problems in [JuMP](https://github.com/JuliaOpt/JuMP.jl) and [ADNLPModel](https://github.com/JuliaSmoothOptimizers/ADNLPModels.jl) syntax.
This package is subdivided in two submodules: `PureJuMP` for the JuMP problems, `ADNLPProblems` for the ADNLPModel problems.

## Problems in JuMP syntax: PureJuMP

You can obtain the list of problems currently defined with `OptimizationProblems.meta[!, :name]`.
```julia
using OptimizationProblems, OptimizationProblems.PureJuMP
problems = OptimizationProblems.meta[!, :name]
length(problems)
```

```plaintext
261
```




Then, it suffices to select any of this problem to get the JuMP model.
```julia
jump_model = OptimizationProblems.PureJuMP.zangwil3()
```

```plaintext
A JuMP Model
Minimization problem with:
Variables: 3
Objective function type: Nonlinear
`JuMP.AffExpr`-in-`MathOptInterface.EqualTo{Float64}`: 3 constraints
Model mode: AUTOMATIC
CachingOptimizer state: NO_OPTIMIZER
Solver name: No optimizer attached.
Names registered in the model: constr1, constr2, constr3, x
```




Note that certain problems are scalable, i.e., their size depends on parameters that can be modified. The list of those problems is available once again using `meta`:
```julia
var_problems = OptimizationProblems.meta[OptimizationProblems.meta.variable_nvar, :name]
length(var_problems)
```

```plaintext
84
```




Then, using the keyword `n`, it is possible to specify the targeted number of variables.
```julia
jump_model_12 = OptimizationProblems.PureJuMP.woods(n=12)
```

```plaintext
A JuMP Model
Minimization problem with:
Variables: 12
Objective function type: Nonlinear
Model mode: AUTOMATIC
CachingOptimizer state: NO_OPTIMIZER
Solver name: No optimizer attached.
Names registered in the model: x
```



```julia
jump_model_120 = OptimizationProblems.PureJuMP.woods(n=120)
```

```plaintext
A JuMP Model
Minimization problem with:
Variables: 120
Objective function type: Nonlinear
Model mode: AUTOMATIC
CachingOptimizer state: NO_OPTIMIZER
Solver name: No optimizer attached.
Names registered in the model: x
```




These problems can be converted as [NLPModels](https://github.com/JuliaSmoothOptimizers/NLPModels.jl) via [NLPModelsJuMP](https://github.com/JuliaSmoothOptimizers/NLPModelsJuMP.jl) to facilitate evaluating
objective, constraints and their derivatives.
```julia
using NLPModels, NLPModelsJuMP
nlp_model_120 = MathOptNLPModel(jump_model_120)
obj(nlp_model_120, zeros(120))
```

```plaintext
Error: ArgumentError: Package NLPModels not found in current path:
- Run `import Pkg; Pkg.add("NLPModels")` to install the NLPModels package.
```





## Problems in ADNLPModel syntax: ADNLPProblems

This package also offers [ADNLPModel](https://github.com/JuliaSmoothOptimizers/ADNLPModels.jl) test problems. This is an optional dependency, so `ADNLPModels` has to be added first.
```julia
using ADNLPModels
```



You can obtain the list of problems currently defined with `OptimizationProblems.meta[!, :name]`:
```julia
using OptimizationProblems, OptimizationProblems.ADNLPProblems
problems = OptimizationProblems.meta[!, :name]
length(problems)
```

```plaintext
261
```




Similarly, to the PureJuMP models, it suffices to select any of this problem to get the model.
```julia
nlp = OptimizationProblems.ADNLPProblems.zangwil3()
```

```plaintext
ADNLPModel - Model with automatic differentiation backend ADNLPModels.ADMod
elBackend{ADNLPModels.ForwardDiffADGradient, ADNLPModels.ForwardDiffADHvpro
d, ADNLPModels.ForwardDiffADJprod, ADNLPModels.ForwardDiffADJtprod, ADNLPMo
dels.ForwardDiffADJacobian, ADNLPModels.ForwardDiffADHessian, ADNLPModels.F
orwardDiffADGHjvprod}(ADNLPModels.ForwardDiffADGradient(ForwardDiff.Gradien
tConfig{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1332"{Flo
at64}, Float64}, Float64, 3, Vector{ForwardDiff.Dual{ForwardDiff.Tag{Optimi
zationProblems.ADNLPProblems.var"#f#1332"{Float64}, Float64}, Float64, 3}}}
((Partials(1.0, 0.0, 0.0), Partials(0.0, 1.0, 0.0), Partials(0.0, 0.0, 1.0)
), ForwardDiff.Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"
#f#1332"{Float64}, Float64}, Float64, 3}[Dual{ForwardDiff.Tag{OptimizationP
roblems.ADNLPProblems.var"#f#1332"{Float64}, Float64}}(0.0,6.94053798457777
e-310,6.94053797593043e-310,0.0), Dual{ForwardDiff.Tag{OptimizationProblems
.ADNLPProblems.var"#f#1332"{Float64}, Float64}}(6.94053798457777e-310,6.940
53797593043e-310,0.0,6.94053798457777e-310), Dual{ForwardDiff.Tag{Optimizat
ionProblems.ADNLPProblems.var"#f#1332"{Float64}, Float64}}(6.94053797593043
e-310,0.0,6.94053798457777e-310,6.94053797593043e-310)])), ADNLPModels.Forw
ardDiffADHvprod(), ADNLPModels.ForwardDiffADJprod(), ADNLPModels.ForwardDif
fADJtprod(), ADNLPModels.ForwardDiffADJacobian(9), ADNLPModels.ForwardDiffA
DHessian(6), ADNLPModels.ForwardDiffADGHjvprod())
  Problem name: zangwil3
   All variables: ████████████████████ 3      All constraints: ████████████
████████ 3     
            free: ████████████████████ 3                 free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0              low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                fixed: ████████████
████████ 3     
          infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: (  0.00% sparsity)   6               linear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                    nonlinear: ████████████
████████ 3     
                                                         nnzj: (  0.00% spa
rsity)   9     

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




Note that some of these problems are scalable, i.e., their size depends on some parameters that can be modified.
```julia
nlp_12 = OptimizationProblems.ADNLPProblems.woods(n=12)
```

```plaintext
ADNLPModel - Model with automatic differentiation backend ADNLPModels.ADMod
elBackend{ADNLPModels.ForwardDiffADGradient, ADNLPModels.ForwardDiffADHvpro
d, ADNLPModels.ForwardDiffADJprod, ADNLPModels.ForwardDiffADJtprod, ADNLPMo
dels.ForwardDiffADJacobian, ADNLPModels.ForwardDiffADHessian, ADNLPModels.F
orwardDiffADGHjvprod}(ADNLPModels.ForwardDiffADGradient(ForwardDiff.Gradien
tConfig{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Flo
at64}, Float64}, Float64, 12, Vector{ForwardDiff.Dual{ForwardDiff.Tag{Optim
izationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}, Float64, 12}
}}((Partials(1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), P
artials(0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), Partia
ls(0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), Partials(0.
0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), Partials(0.0, 0.
0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), Partials(0.0, 0.0, 0.
0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), Partials(0.0, 0.0, 0.0, 0.
0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0), Partials(0.0, 0.0, 0.0, 0.0, 0.
0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0), Partials(0.0, 0.0, 0.0, 0.0, 0.0, 0.
0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0), Partials(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.
0, 0.0, 0.0, 1.0, 0.0, 0.0), Partials(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.
0, 0.0, 0.0, 1.0, 0.0), Partials(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.
0, 0.0, 0.0, 1.0)), ForwardDiff.Dual{ForwardDiff.Tag{OptimizationProblems.A
DNLPProblems.var"#f#1329"{Float64}, Float64}, Float64, 12}[Dual{ForwardDiff
.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.
94048408567505e-310,6.9404840856782e-310,2.5e-323,4.4e-323,6.9404840856814e
-310,6.94048408568454e-310,5.0e-323,5.0e-323,6.9404840856877e-310,6.9404840
8569086e-310,5.4e-323,6.0e-323,6.940484085694e-310), Dual{ForwardDiff.Tag{O
ptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.940484
0856972e-310,6.4e-323,7.4e-323,6.94048408570035e-310,6.9404840857035e-310,8
.0e-323,8.0e-323,6.94048408570667e-310,6.94048408570983e-310,8.4e-323,9.0e-
323,6.940484085713e-310,6.94048408571616e-310), Dual{ForwardDiff.Tag{Optimi
zationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(9.4e-323,1.0e
-322,6.94048408572564e-310,6.9404840857288e-310,1.04e-322,1.14e-322,6.94048
408573197e-310,6.94048408573513e-310,1.2e-322,1.2e-322,6.9404840857383e-310
,6.94048408574145e-310,1.24e-322), Dual{ForwardDiff.Tag{OptimizationProblem
s.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(1.33e-322,6.9404840857446e
-310,6.9404840857478e-310,1.4e-322,1.4e-322,6.94048408575094e-310,6.9404840
857541e-310,1.43e-322,1.5e-322,6.94048408575726e-310,6.94048563046734e-310,
1.53e-322,1.6e-322), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblem
s.var"#f#1329"{Float64}, Float64}}(6.94048591363257e-310,6.9404864420757e-3
10,1.63e-322,1.73e-322,6.94048644207886e-310,6.940486442082e-310,1.8e-322,1
.8e-322,6.9404864420852e-310,6.94048644208834e-310,1.83e-322,2.1e-322,6.940
4864420915e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.v
ar"#f#1329"{Float64}, Float64}}(6.94048644209467e-310,2.17e-322,2.17e-322,6
.94048644213894e-310,6.94048644213577e-310,6.9405489613097e-310,6.940548961
3097e-310,6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.
9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310), Dual{Forward
Diff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}
}(6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.94054896
13097e-310,6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6
.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.94054896130
97e-310,6.9405489613097e-310,6.9405489613097e-310), Dual{ForwardDiff.Tag{Op
timizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.9405489
613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,
6.9405489613097e-310,6.94053807460443e-310,6.9405489613097e-310,6.940548961
3097e-310,6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.
9405489613097e-310,6.9405489613097e-310), Dual{ForwardDiff.Tag{Optimization
Problems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.9405489613097e-31
0,6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.94054896
13097e-310,6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6
.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.94054896130
97e-310,6.9405489613097e-310), Dual{ForwardDiff.Tag{OptimizationProblems.AD
NLPProblems.var"#f#1329"{Float64}, Float64}}(6.9405489613097e-310,6.9405489
613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,
6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.9405489613
097e-310,6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.9
405489613097e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems
.var"#f#1329"{Float64}, Float64}}(6.9405489613097e-310,6.9405489613097e-310
,6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.940548961
3097e-310,6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.
9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.940548961309
7e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#132
9"{Float64}, Float64}}(6.9405489613097e-310,6.9405489613097e-310,6.94054896
13097e-310,6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6
.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310,6.94054896130
97e-310,6.9405489613097e-310,6.9405489613097e-310,6.9405489613097e-310)])),
 ADNLPModels.ForwardDiffADHvprod(), ADNLPModels.ForwardDiffADJprod(), ADNLP
Models.ForwardDiffADJtprod(), ADNLPModels.ForwardDiffADJacobian(0), ADNLPMo
dels.ForwardDiffADHessian(78), ADNLPModels.ForwardDiffADGHjvprod())
  Problem name: woods
   All variables: ████████████████████ 12     All constraints: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            free: ████████████████████ 12                free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0              low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
          infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: (  0.00% sparsity)   78              linear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                    nonlinear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                         nnzj: (------% spa
rsity)         

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



```julia
nlp_120 = OptimizationProblems.ADNLPProblems.woods(n=120)
```

```plaintext
ADNLPModel - Model with automatic differentiation backend ADNLPModels.ADMod
elBackend{ADNLPModels.ForwardDiffADGradient, ADNLPModels.ForwardDiffADHvpro
d, ADNLPModels.ForwardDiffADJprod, ADNLPModels.ForwardDiffADJtprod, ADNLPMo
dels.ForwardDiffADJacobian, ADNLPModels.ForwardDiffADHessian, ADNLPModels.F
orwardDiffADGHjvprod}(ADNLPModels.ForwardDiffADGradient(ForwardDiff.Gradien
tConfig{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Flo
at64}, Float64}, Float64, 12, Vector{ForwardDiff.Dual{ForwardDiff.Tag{Optim
izationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}, Float64, 12}
}}((Partials(1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), P
artials(0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), Partia
ls(0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), Partials(0.
0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), Partials(0.0, 0.
0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), Partials(0.0, 0.0, 0.
0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), Partials(0.0, 0.0, 0.0, 0.
0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0), Partials(0.0, 0.0, 0.0, 0.0, 0.
0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0), Partials(0.0, 0.0, 0.0, 0.0, 0.0, 0.
0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0), Partials(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.
0, 0.0, 0.0, 1.0, 0.0, 0.0), Partials(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.
0, 0.0, 0.0, 1.0, 0.0), Partials(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.
0, 0.0, 0.0, 1.0)), ForwardDiff.Dual{ForwardDiff.Tag{OptimizationProblems.A
DNLPProblems.var"#f#1329"{Float64}, Float64}, Float64, 12}[Dual{ForwardDiff
.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(5.
0e-324,1.57010386e-316,NaN,4.6528747e-316,0.0,NaN,0.0,6.7139031e-316,6.2585
6985e-316,6.9533123648278e-310,1.57010386e-316,NaN,0.0), Dual{ForwardDiff.T
ag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(4.58
76857e-316,NaN,4.6561126e-316,0.0,NaN,0.0,4.6043701e-316,NaN,0.0,0.0,NaN,0.
0,6.94054896139706e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPr
oblems.var"#f#1329"{Float64}, Float64}}(3.1292798e-316,5.0e-324,1.57010386e
-316,NaN,0.0,6.94054896141604e-310,NaN,4.64963677e-316,0.0,2.2046885e-316,5
.0e-324,1.57010386e-316,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADN
LPProblems.var"#f#1329"{Float64}, Float64}}(0.0,0.0,6.3454511e-316,5.0e-324
,1.57010386e-316,NaN,0.0,0.0,1.538722e-316,5.0e-324,1.57010386e-316,NaN,4.6
528747e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#
f#1329"{Float64}, Float64}}(0.0,NaN,0.0,3.3490726e-316,5.4350968e-316,4.649
6368e-316,1.57010386e-316,2.0354896e-316,5.0e-324,1.57010386e-316,8.1574483
e-316,4.65287473e-316,1.57010386e-316), Dual{ForwardDiff.Tag{OptimizationPr
oblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(2.30119177e-316,5.0e-
324,1.57010386e-316,5.29513235e-316,5.0e-324,1.57010386e-316,2.2539994e-316
,5.0e-324,1.57010386e-316,3.2078117e-316,4.65611264e-316,1.57010386e-316,1.
8616765e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"
#f#1329"{Float64}, Float64}}(5.0e-324,1.57010386e-316,NaN,4.65638344e-316,0
.0,NaN,0.0,2.335125e-316,NaN,4.64963677e-316,0.0,NaN,0.0), Dual{ForwardDiff
.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.
71392367e-316,2.33507677e-316,4.65287473e-316,1.57010386e-316,1.44178e-316,
5.0e-324,1.57010386e-316,2.93456733e-316,5.0e-324,1.57010386e-316,8.9951496
6e-316,5.0e-324,1.57010386e-316), Dual{ForwardDiff.Tag{OptimizationProblems
.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(NaN,4.6528747e-316,0.0,NaN,
0.0,3.34911054e-316,6.24939367e-316,5.0e-324,1.57010386e-316,NaN,0.0,6.9405
489616785e-310,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblem
s.var"#f#1329"{Float64}, Float64}}(4.6528747e-316,0.0,NaN,0.0,3.3491619e-31
6,NaN,4.6561126e-316,0.0,NaN,0.0,4.58762007e-316,NaN,0.0), Dual{ForwardDiff
.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.
0,NaN,0.0,6.9405489617354e-310,NaN,4.6528747e-316,0.0,NaN,0.0,4.60439064e-3
16,NaN,0.0,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.va
r"#f#1329"{Float64}, Float64}}(NaN,0.0,6.94054896177334e-310,6.08644054e-31
6,5.0e-324,1.57010386e-316,6.39266717e-316,5.0e-324,1.57010386e-316,NaN,0.0
,0.0,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1
329"{Float64}, Float64}}(0.0,6.9405489618113e-310,NaN,0.0,0.0,3.5040511e-31
6,5.0e-324,1.57010386e-316,NaN,0.0,0.0,NaN,0.0), Dual{ForwardDiff.Tag{Optim
izationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.9405489618
4923e-310,NaN,0.0,0.0,6.3952126e-316,5.0e-324,1.57010386e-316,4.4778798e-31
6,4.6496368e-316,1.57010386e-316,NaN,0.0,8.68918073e-316), Dual{ForwardDiff
.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(2.
7870575e-316,4.6496368e-316,1.57010386e-316,4.484139e-316,5.0e-324,1.570103
86e-316,8.13158615e-316,4.6496368e-316,1.57010386e-316,8.72395584e-316,5.0e
-324,1.57010386e-316,5.5082517e-316), Dual{ForwardDiff.Tag{OptimizationProb
lems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(5.0e-324,1.57010386e-31
6,9.6882945e-316,5.0e-324,1.57010386e-316,3.5219537e-316,5.0e-324,1.5701038
6e-316,6.39266164e-316,5.0e-324,1.57010386e-316,NaN,4.6561126e-316), Dual{F
orwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Fl
oat64}}(0.0,2.32998434e-316,5.0e-324,1.57010386e-316,2.25739937e-316,4.6528
7473e-316,1.57010386e-316,2.4458115e-316,5.0e-324,1.57010386e-316,7.6074726
e-317,5.0e-324,1.57010386e-316), Dual{ForwardDiff.Tag{OptimizationProblems.
ADNLPProblems.var"#f#1329"{Float64}, Float64}}(5.35617515e-316,5.0e-324,1.5
7010386e-316,NaN,6.9533123648151e-310,6.9533123648396e-310,3.17478284e-316,
5.0e-324,1.57010386e-316,NaN,0.0,0.0,NaN), Dual{ForwardDiff.Tag{Optimizatio
nProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,6.940548962057
93e-310,3.52194024e-316,5.0e-324,1.57010386e-316,2.4220244e-316,5.0e-324,1.
57010386e-316,4.58285017e-316,5.0e-324,1.57010386e-316,NaN,0.0), Dual{Forwa
rdDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float6
4}}(6.94054896209587e-310,1.3867316e-316,4.6496368e-316,1.57010386e-316,6.2
0964865e-316,5.0e-324,1.57010386e-316,NaN,0.0,0.0,NaN,0.0,6.9405489621338e-
310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{
Float64}, Float64}}(NaN,0.0,0.0,NaN,0.0,6.9405489621528e-310,NaN,4.6561126e
-316,0.0,NaN,0.0,6.71380114e-316,NaN), Dual{ForwardDiff.Tag{OptimizationPro
blems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(4.6528747e-316,0.0,NaN
,0.0,2.33513052e-316,NaN,6.9533123648151e-310,6.9533123648396e-310,NaN,0.0,
8.15728547e-316,NaN,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPr
oblems.var"#f#1329"{Float64}, Float64}}(0.0,NaN,0.0,6.94054896222867e-310,2
.3433818e-316,4.65611264e-316,1.57010386e-316,NaN,0.0,6.7139134e-316,NaN,0.
0,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329
"{Float64}, Float64}}(2.5515558e-316,5.0e-324,1.57010386e-316,NaN,1.0e-323,
0.0,NaN,0.0,6.9405489622856e-310,NaN,0.0,0.0,6.39468375e-316), Dual{Forward
Diff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}
}(5.0e-324,1.57010386e-316,NaN,0.0,0.0,NaN,0.0,6.94054896232354e-310,NaN,0.
0,0.0,NaN,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var
"#f#1329"{Float64}, Float64}}(6.9405489623425e-310,NaN,6.9533123648151e-310
,6.9533123648396e-310,NaN,0.0,8.1572752e-316,2.5289987e-316,4.65287473e-316
,1.57010386e-316,1.9758191e-316,5.0e-324,1.57010386e-316), Dual{ForwardDiff
.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.
5818202e-316,6.9533123648278e-310,1.57010386e-316,3.9803636e-316,5.0e-324,1
.57010386e-316,NaN,4.64963677e-316,0.0,NaN,0.0,3.34909e-316,4.93035064e-316
), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Flo
at64}, Float64}}(4.6496368e-316,1.57010386e-316,9.30938253e-316,5.0e-324,1.
57010386e-316,NaN,4.6528747e-316,0.0,8.97165427e-316,5.0e-324,1.57010386e-3
16,2.7411355e-316,4.65287473e-316), Dual{ForwardDiff.Tag{OptimizationProble
ms.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(1.57010386e-316,2.8406268
7e-316,5.0e-324,1.57010386e-316,9.20244933e-316,4.6564162e-316,1.57010386e-
316,NaN,0.0,3.6795527e-316,NaN,4.6523748e-316,0.0), Dual{ForwardDiff.Tag{Op
timizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(NaN,0.0,2
.33512025e-316,NaN,0.0,0.0,NaN,0.0,6.94054896253223e-310,2.8569824e-316,4.6
5287473e-316,1.57010386e-316,NaN), Dual{ForwardDiff.Tag{OptimizationProblem
s.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,5.8684335e-316,NaN,0.0
,0.0,1.41434473e-316,5.0e-324,1.57010386e-316,NaN,0.0,0.0,NaN,0.0), Dual{Fo
rwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Flo
at64}}(6.94054896258914e-310,NaN,4.6528747e-316,0.0,8.1569155e-316,5.0e-324
,1.57010386e-316,NaN,4.6528747e-316,0.0,NaN,0.0,6.71389284e-316), Dual{Forw
ardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float
64}}(NaN,4.6528747e-316,0.0,2.58417755e-316,5.0e-324,1.57010386e-316,NaN,1.
0e-323,0.0,1.991298e-316,5.0e-324,1.57010386e-316,NaN), Dual{ForwardDiff.Ta
g{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(4.652
37953e-316,0.0,NaN,0.0,4.6043851e-316,NaN,0.0,0.0,NaN,0.0,6.940548962703e-3
10,NaN,1.0e-323), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.v
ar"#f#1329"{Float64}, Float64}}(0.0,NaN,0.0,6.94054896272195e-310,NaN,0.0,0
.0,NaN,0.0,6.9405489627409e-310,NaN,0.0,0.0), Dual{ForwardDiff.Tag{Optimiza
tionProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(NaN,0.0,6.94054
89627599e-310,NaN,4.64963677e-316,0.0,2.43939577e-316,5.0e-324,1.57010386e-
316,3.665443e-316,4.65287473e-316,1.57010386e-316,NaN), Dual{ForwardDiff.Ta
g{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,3
.34911607e-316,1.85931764e-316,4.65287473e-316,1.57010386e-316,3.5944185e-3
16,5.0e-324,1.57010386e-316,NaN,1.0e-323,0.0,NaN,0.0), Dual{ForwardDiff.Tag
{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.9405
489628358e-310,NaN,4.64963677e-316,0.0,3.46610133e-316,5.0e-324,1.57010386e
-316,NaN,0.0,0.0,NaN,0.0,6.94054896287373e-310), Dual{ForwardDiff.Tag{Optim
izationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(NaN,0.0,0.0,
NaN,0.0,6.9405489628927e-310,NaN,4.64963677e-316,0.0,NaN,0.0,8.6892566e-316
,1.75920097e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.
var"#f#1329"{Float64}, Float64}}(4.65287473e-316,1.57010386e-316,2.7345972e
-316,5.0e-324,1.57010386e-316,NaN,4.6561126e-316,0.0,NaN,0.0,3.6793891e-316
,3.1423002e-316,4.6496368e-316), Dual{ForwardDiff.Tag{OptimizationProblems.
ADNLPProblems.var"#f#1329"{Float64}, Float64}}(1.57010386e-316,6.01756305e-
316,5.0e-324,1.57010386e-316,3.2031169e-316,4.65198937e-316,1.57010386e-316
,NaN,0.0,9.66948365e-316,2.73460434e-316,5.0e-324,1.57010386e-316), Dual{Fo
rwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Flo
at64}}(8.97102424e-316,5.0e-324,1.57010386e-316,4.47798177e-316,4.65287473e
-316,1.57010386e-316,4.48572476e-316,5.0e-324,1.57010386e-316,NaN,0.0,0.0,1
.63097e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#
f#1329"{Float64}, Float64}}(5.0e-324,1.57010386e-316,NaN,0.0,0.0,NaN,0.0,6.
94054896306345e-310,NaN,0.0,0.0,NaN,0.0), Dual{ForwardDiff.Tag{Optimization
Problems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.9405489630824e-31
0,NaN,0.0,0.0,NaN,0.0,6.9405489631014e-310,1.6481461e-316,4.6550249e-316,1.
57010386e-316,NaN,0.0,2.33518586e-316), Dual{ForwardDiff.Tag{OptimizationPr
oblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.38209673e-316,5.0e-
324,1.57010386e-316,NaN,0.0,6.94054896313934e-310,NaN,4.65179456e-316,0.0,N
aN,0.0,6.71391814e-316,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNL
PProblems.var"#f#1329"{Float64}, Float64}}(6.9533123648151e-310,0.0,NaN,0.0
,2.3352333e-316,NaN,0.0,0.0,NaN,0.0,6.94054896319625e-310,NaN,0.0), Dual{Fo
rwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Flo
at64}}(0.0,NaN,0.0,6.94054896321522e-310,2.5654173e-316,5.0e-324,1.57010386
e-316,3.1243241e-316,0.0,1.57010386e-316,8.7598353e-316,4.6496368e-316,1.57
010386e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#
f#1329"{Float64}, Float64}}(NaN,0.0,9.66942437e-316,NaN,4.64963677e-316,0.0
,NaN,0.0,9.6694544e-316,NaN,6.9533123648318e-310,6.9533123648396e-310,NaN),
 Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float
64}, Float64}}(0.0,2.335223e-316,1.6481619e-316,4.65179964e-316,1.57010386e
-316,NaN,0.0,6.71391814e-316,NaN,4.6528747e-316,0.0,4.64750083e-316,5.0e-32
4), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Fl
oat64}, Float64}}(1.57010386e-316,NaN,0.0,0.0,NaN,0.0,6.94054896334803e-310
,NaN,1.0e-323,0.0,NaN,0.0,6.940548963367e-310), Dual{ForwardDiff.Tag{Optimi
zationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(NaN,0.0,0.0,1
.7455023e-316,5.0e-324,1.57010386e-316,NaN,4.64963677e-316,0.0,NaN,0.0,2.33
519693e-316,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.v
ar"#f#1329"{Float64}, Float64}}(0.0,0.0,NaN,0.0,6.9405489634239e-310,2.6721
394e-316,5.0e-324,1.57010386e-316,8.9481976e-316,5.0e-324,1.57010386e-316,8
.68487485e-316,4.65611264e-316), Dual{ForwardDiff.Tag{OptimizationProblems.
ADNLPProblems.var"#f#1329"{Float64}, Float64}}(1.57010386e-316,1.60033e-316
,5.0e-324,1.57010386e-316,9.49921836e-316,4.65611264e-316,1.57010386e-316,8
.43248715e-316,5.0e-324,1.57010386e-316,9.10596107e-316,5.0e-324,1.57010386
e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329
"{Float64}, Float64}}(NaN,0.0,6.9405489634998e-310,NaN,0.0,0.0,NaN,0.0,6.94
05489635188e-310,NaN,0.0,0.0,1.44490407e-316), Dual{ForwardDiff.Tag{Optimiz
ationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(5.0e-324,1.570
10386e-316,NaN,4.6562633e-316,0.0,NaN,0.0,4.58761454e-316,NaN,1.0e-323,0.0,
NaN,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#13
29"{Float64}, Float64}}(6.9405489635757e-310,9.30929004e-316,4.6496368e-316
,1.57010386e-316,9.12482727e-316,5.0e-324,1.57010386e-316,NaN,4.6528747e-31
6,0.0,NaN,0.0,2.3352388e-316), Dual{ForwardDiff.Tag{OptimizationProblems.AD
NLPProblems.var"#f#1329"{Float64}, Float64}}(NaN,4.6561126e-316,0.0,NaN,0.0
,8.6892005e-316,2.8672147e-316,5.0e-324,1.57010386e-316,9.12482173e-316,5.0
e-324,1.57010386e-316,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLP
Problems.var"#f#1329"{Float64}, Float64}}(4.6528747e-316,0.0,NaN,0.0,2.3351
3527e-316,NaN,4.6528747e-316,0.0,NaN,0.0,8.6893064e-316,NaN,4.6570791e-316)
, Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Floa
t64}, Float64}}(0.0,NaN,0.0,4.6044254e-316,4.4873216e-316,4.6496368e-316,1.
57010386e-316,NaN,0.0,2.3351408e-316,NaN,1.0e-323,0.0), Dual{ForwardDiff.Ta
g{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(2.762
6641e-316,5.0e-324,1.57010386e-316,NaN,0.0,0.0,NaN,0.0,4.0e-322,NaN,0.0,0.0
,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"
{Float64}, Float64}}(0.0,0.0,6.19820056e-316,4.65287473e-316,1.57010386e-31
6,NaN,0.0,8.68919733e-316,NaN,4.65627356e-316,0.0,NaN,0.0), Dual{ForwardDif
f.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3
.34910026e-316,NaN,4.6528747e-316,5.0e-324,2.27594304e-316,5.0e-324,1.57010
386e-316,2.6440259e-316,4.6496368e-316,1.57010386e-316,NaN,0.0,3.34911607e-
316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{
Float64}, Float64}}(1.587425e-316,5.0e-324,1.57010386e-316,9.35336385e-316,
5.0e-324,1.57010386e-316,4.406679e-316,4.65566996e-316,1.57010386e-316,NaN,
0.0,2.6159503e-316,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPro
blems.var"#f#1329"{Float64}, Float64}}(1.0e-323,0.0,3.089817e-316,5.0e-324,
1.57010386e-316,2.2759296e-316,5.0e-324,1.57010386e-316,4.9660973e-316,5.0e
-324,1.57010386e-316,3.14535945e-316,4.6554676e-316), Dual{ForwardDiff.Tag{
OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(1.57010
386e-316,NaN,0.0,2.6159448e-316,NaN,1.0e-323,0.0,NaN,0.0,0.0,NaN,4.6528747e
-316,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1
329"{Float64}, Float64}}(NaN,0.0,4.60443095e-316,NaN,4.65243645e-316,0.0,Na
N,0.0,4.5877418e-316,NaN,6.9533123648318e-310,6.9533123648396e-310,2.455563
97e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#13
29"{Float64}, Float64}}(5.0e-324,1.57010386e-316,NaN,4.64963677e-316,0.0,9.
79548e-317,5.0e-324,1.57010386e-316,1.63714936e-316,4.65101546e-316,1.57010
386e-316,2.48438894e-316,5.0e-324), Dual{ForwardDiff.Tag{OptimizationProble
ms.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(1.57010386e-316,2.9841177
7e-316,5.0e-324,1.57010386e-316,8.94893357e-316,5.0e-324,1.57010386e-316,2.
19484987e-316,4.65708654e-316,1.57010386e-316,NaN,0.0,8.68921314e-316), Dua
l{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64},
 Float64}}(8.06236084e-316,5.0e-324,1.57010386e-316,8.7430094e-316,5.0e-324
,1.57010386e-316,NaN,4.64963677e-316,0.0,9.23016127e-316,5.0e-324,1.5701038
6e-316,4.2374951e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProb
lems.var"#f#1329"{Float64}, Float64}}(6.95331236481515e-310,1.57010386e-316
,NaN,0.0,4.58770624e-316,NaN,4.64963677e-316,0.0,NaN,0.0,6.713964e-316,3.68
55653e-316,4.65406365e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNL
PProblems.var"#f#1329"{Float64}, Float64}}(1.57010386e-316,NaN,0.0,4.604390
64e-316,NaN,1.0e-323,0.0,NaN,0.0,5.0e-324,NaN,1.0e-323,0.0), Dual{ForwardDi
ff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(
2.5654489e-316,5.0e-324,1.57010386e-316,NaN,1.0e-323,0.0,NaN,0.0,5.0e-324,N
aN,1.0e-323,0.0,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProble
ms.var"#f#1329"{Float64}, Float64}}(0.0,0.0,NaN,0.0,0.0,NaN,0.0,0.0,NaN,4.6
528747e-316,0.0,NaN,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPr
oblems.var"#f#1329"{Float64}, Float64}}(4.6043851e-316,NaN,1.0e-323,0.0,2.6
794761e-316,5.0e-324,1.57010386e-316,NaN,0.0,0.0,NaN,0.0,5.0e-324), Dual{Fo
rwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Flo
at64}}(6.712032e-316,4.65287473e-316,1.57010386e-316,3.1662027e-316,5.0e-32
4,1.57010386e-316,2.72836093e-316,4.65611264e-316,1.57010386e-316,NaN,0.0,9
.6695121e-316,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems
.var"#f#1329"{Float64}, Float64}}(0.0,0.0,NaN,0.0,1.0e-323,NaN,0.0,0.0,6.71
20233e-316,5.0e-324,1.57010386e-316,9.520543e-316,5.0e-324), Dual{ForwardDi
ff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(
1.57010386e-316,NaN,0.0,0.0,NaN,4.6561126e-316,0.0,9.038399e-316,0.0,1.5701
0386e-316,NaN,0.0,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProb
lems.var"#f#1329"{Float64}, Float64}}(2.18909895e-316,5.0e-324,1.57010386e-
316,6.3950355e-316,5.0e-324,1.57010386e-316,5.22845404e-316,5.0e-324,1.5701
0386e-316,NaN,6.9533123648808e-310,6.9533123649052e-310,NaN), Dual{ForwardD
iff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}
(0.0,2.33513527e-316,NaN,0.0,0.0,3.00543927e-316,5.0e-324,1.57010386e-316,N
aN,1.0e-323,0.0,3.3033253e-316,5.0e-324), Dual{ForwardDiff.Tag{Optimization
Problems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(1.57010386e-316,NaN
,0.0,0.0,NaN,0.0,5.0e-324,NaN,0.0,0.0,NaN,0.0,5.0e-324), Dual{ForwardDiff.T
ag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(NaN,
0.0,0.0,NaN,0.0,1.0e-323,NaN,1.0e-323,0.0,NaN,0.0,0.0,NaN), Dual{ForwardDif
f.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(4
.64963677e-316,0.0,9.2814935e-316,5.0e-324,1.57010386e-316,5.72313233e-316,
5.0e-324,1.57010386e-316,NaN,0.0,5.0e-324,NaN,0.0), Dual{ForwardDiff.Tag{Op
timizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,NaN,0
.0,5.0e-324,8.0999628e-316,4.65611264e-316,1.57010386e-316,NaN,0.0,8.689192
6e-316,3.48959356e-316,5.0e-324,1.57010386e-316), Dual{ForwardDiff.Tag{Opti
mizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(9.28149983e
-316,5.0e-324,1.57010386e-316,1.75915196e-316,5.0e-324,1.57010386e-316,2.96
230615e-316,5.0e-324,1.57010386e-316,NaN,1.0e-323,0.0,NaN), Dual{ForwardDif
f.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0
.0,5.0e-324,1.6149164e-316,5.0e-324,1.57010386e-316,8.10919747e-316,5.0e-32
4,1.57010386e-316,8.0495349e-316,5.0e-324,1.57010386e-316,NaN,0.0), Dual{Fo
rwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Flo
at64}}(5.0e-324,NaN,4.6528747e-316,0.0,2.54254877e-316,5.0e-324,1.57010386e
-316,3.14577763e-316,4.65671975e-316,1.57010386e-316,NaN,0.0,8.68921314e-31
6), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Fl
oat64}, Float64}}(NaN,6.9533123648318e-310,6.9533123648396e-310,9.36432263e
-316,5.0e-324,1.57010386e-316,2.33531867e-316,4.65247e-316,1.57010386e-316,
1.62965063e-316,5.0e-324,1.57010386e-316,2.87339726e-316), Dual{ForwardDiff
.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(5.
0e-324,1.57010386e-316,9.28151406e-316,5.0e-324,1.57010386e-316,NaN,4.65470
124e-316,0.0,5.71805097e-316,5.0e-324,1.57010386e-316,1.70366325e-316,5.0e-
324), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{
Float64}, Float64}}(1.57010386e-316,2.4352219e-316,5.0e-324,1.57010386e-316
,NaN,4.6528747e-316,0.0,9.09633114e-316,5.0e-324,1.57010386e-316,NaN,6.9533
123648318e-310,6.9533123648396e-310), Dual{ForwardDiff.Tag{OptimizationProb
lems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(5.1536035e-316,5.0e-324
,1.57010386e-316,NaN,0.0,0.0,NaN,NaN,0.0,3.22564e-316,5.0e-324,1.57010386e-
316,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#13
29"{Float64}, Float64}}(0.0,0.0,NaN,1.0e-323,0.0,NaN,0.0,0.0,NaN,1.0e-323,0
.0,3.02954177e-316,5.0e-324), Dual{ForwardDiff.Tag{OptimizationProblems.ADN
LPProblems.var"#f#1329"{Float64}, Float64}}(1.57010386e-316,NaN,1.0e-323,0.
0,NaN,0.0,5.0e-324,3.7360351e-316,5.0e-324,1.57010386e-316,NaN,-0.0,0.0), D
ual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64
}, Float64}}(NaN,0.0,0.0,NaN,0.0,0.0,NaN,0.0,0.0,2.34352806e-316,5.0e-324,1
.57010386e-316,2.8335811e-316), Dual{ForwardDiff.Tag{OptimizationProblems.A
DNLPProblems.var"#f#1329"{Float64}, Float64}}(6.95331236481515e-310,1.57010
386e-316,2.265823e-316,5.0e-324,1.57010386e-316,1.5820883e-316,5.0e-324,1.5
7010386e-316,NaN,0.0,5.0e-324,NaN,1.0e-323), Dual{ForwardDiff.Tag{Optimizat
ionProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,NaN,0.0,5.0e
-324,NaN,0.0,0.0,NaN,0.0,5.0e-324,NaN,0.0,0.0), Dual{ForwardDiff.Tag{Optimi
zationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(NaN,0.0,5.0e-
324,NaN,0.0,0.0,3.3113592e-316,5.0e-324,1.57010386e-316,6.46398495e-316,5.0
e-324,1.57010386e-316,2.9568651e-316), Dual{ForwardDiff.Tag{OptimizationPro
blems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(5.0e-324,1.57010386e-3
16,NaN,4.64963677e-316,0.0,NaN,0.0,9.66942753e-316,NaN,4.6528747e-316,0.0,2
.34349565e-316,5.0e-324), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPr
oblems.var"#f#1329"{Float64}, Float64}}(1.57010386e-316,NaN,4.652491e-316,0
.0,NaN,0.0,2.3351076e-316,9.2816508e-316,5.0e-324,1.57010386e-316,3.3113647
e-316,5.0e-324,1.57010386e-316), Dual{ForwardDiff.Tag{OptimizationProblems.
ADNLPProblems.var"#f#1329"{Float64}, Float64}}(NaN,0.0,0.0,8.75808827e-316,
5.0e-324,1.57010386e-316,3.005527e-316,4.65287473e-316,1.57010386e-316,NaN,
0.0,8.6891752e-316,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPro
blems.var"#f#1329"{Float64}, Float64}}(4.6528747e-316,0.0,NaN,0.0,6.7139695
e-316,NaN,0.0,0.0,NaN,0.0,5.0e-324,NaN,0.0), Dual{ForwardDiff.Tag{Optimizat
ionProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,NaN,0.0,5.0e
-324,NaN,4.65371153e-316,0.0,NaN,0.0,4.6043598e-316,NaN,6.9533123648151e-31
0,6.9533123648396e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPro
blems.var"#f#1329"{Float64}, Float64}}(4.5782518e-316,5.0e-324,1.57010386e-
316,NaN,0.0,0.0,NaN,0.0,0.0,NaN,1.0e-323,0.0,NaN), Dual{ForwardDiff.Tag{Opt
imizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,5.0e-3
24,2.4235738e-316,5.0e-324,1.57010386e-316,NaN,0.0,1.0e-323,NaN,4.64963677e
-316,0.0,NaN,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.
var"#f#1329"{Float64}, Float64}}(8.15734713e-316,2.4827937e-316,5.0e-324,1.
57010386e-316,NaN,0.0,5.0e-324,NaN,0.0,0.0,2.3434664e-316,5.0e-324,1.570103
86e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#13
29"{Float64}, Float64}}(NaN,0.0,0.0,4.2151752e-316,5.0e-324,1.57010386e-316
,3.99458083e-316,5.0e-324,1.57010386e-316,9.29337717e-316,5.0e-324,1.570103
86e-316,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#
f#1329"{Float64}, Float64}}(0.0,0.0,NaN,0.0,5.0e-324,1.5898732e-316,4.65287
473e-316,1.57010386e-316,4.5782439e-316,5.0e-324,1.57010386e-316,NaN,6.9533
123648151e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.va
r"#f#1329"{Float64}, Float64}}(6.9533123648396e-310,1.4996094e-316,5.0e-324
,1.57010386e-316,NaN,4.6528747e-316,0.0,1.50117775e-316,5.0e-324,1.57010386
e-316,4.841969e-316,5.0e-324,1.57010386e-316), Dual{ForwardDiff.Tag{Optimiz
ationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(NaN,0.0,0.0,Na
N,0.0,0.0,2.48280714e-316,5.0e-324,1.57010386e-316,2.98435176e-316,5.0e-324
,1.57010386e-316,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProbl
ems.var"#f#1329"{Float64}, Float64}}(0.0,0.0,2.32656224e-316,5.0e-324,1.570
10386e-316,9.2902183e-316,5.0e-324,1.57010386e-316,NaN,4.64963677e-316,0.0,
8.66029963e-316,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProble
ms.var"#f#1329"{Float64}, Float64}}(1.57010386e-316,NaN,0.0,0.0,NaN,0.0,5.0
e-324,NaN,0.0,0.0,2.5051737e-316,0.0,1.57010386e-316), Dual{ForwardDiff.Tag
{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(2.7124
022e-316,5.0e-324,1.57010386e-316,2.36385353e-316,5.0e-324,1.57010386e-316,
NaN,1.0e-323,0.0,9.2302024e-316,5.0e-324,1.57010386e-316,NaN), Dual{Forward
Diff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}
}(4.6528747e-316,0.0,NaN,0.0,8.9475581e-316,NaN,0.0,0.0,2.94788734e-316,5.0
e-324,1.57010386e-316,NaN,4.6528747e-316), Dual{ForwardDiff.Tag{Optimizatio
nProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,3.57306536e-31
6,5.0e-324,1.57010386e-316,6.39260314e-316,4.65287473e-316,1.57010386e-316,
2.32657015e-316,5.0e-324,1.57010386e-316,2.2963768e-316,5.0e-324,1.57010386
e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329
"{Float64}, Float64}}(3.20257304e-316,5.0e-324,1.57010386e-316,NaN,6.953312
3648318e-310,6.9533123648396e-310,NaN,0.0,8.15728547e-316,NaN,0.0,0.0,9.096
3675e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#
1329"{Float64}, Float64}}(5.0e-324,1.57010386e-316,NaN,4.6528747e-316,0.0,N
aN,0.0,4.60437483e-316,NaN,4.6528747e-316,0.0,NaN,0.0), Dual{ForwardDiff.Ta
g{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.713
90786e-316,NaN,4.6528747e-316,0.0,3.1668754e-316,0.0,1.57010386e-316,3.1413
6345e-316,5.0e-324,1.57010386e-316,NaN,0.0,0.0), Dual{ForwardDiff.Tag{Optim
izationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(NaN,4.652874
7e-316,0.0,NaN,0.0,8.6892076e-316,NaN,4.6528747e-316,0.0,NaN,0.0,8.68926216
e-316,1.0e-323), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.va
r"#f#1329"{Float64}, Float64}}(2.85e-321,6.940555131092e-310,8.6602957e-316
,5.0e-324,0.0,5.0e-324,5.0e-324,0.0,0.0,0.0,5.0e-324,5.0e-324,5.0e-324), Du
al{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}
, Float64}}(0.0,5.0e-324,0.0,5.0e-324,1.5e-323,5.0e-324,0.0,0.0,5.0e-324,5.
0e-324,1.0e-323,5.0e-324,5.0e-324), Dual{ForwardDiff.Tag{OptimizationProble
ms.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(5.0e-324,5.0e-324,0.0,5.0
e-324,5.0e-324,0.0,0.0,0.0,5.0e-324,5.0e-324,5.0e-324,5.0e-324,0.0)])), ADN
LPModels.ForwardDiffADHvprod(), ADNLPModels.ForwardDiffADJprod(), ADNLPMode
ls.ForwardDiffADJtprod(), ADNLPModels.ForwardDiffADJacobian(0), ADNLPModels
.ForwardDiffADHessian(7260), ADNLPModels.ForwardDiffADGHjvprod())
  Problem name: woods
   All variables: ████████████████████ 120    All constraints: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            free: ████████████████████ 120               free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0              low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
          infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: (  0.00% sparsity)   7260            linear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                    nonlinear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                         nnzj: (------% spa
rsity)         

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




One of the advantages of these problems is that they are type-stable. Indeed, one can specify the output type with the keyword `type` as follows.
```julia
nlp16_12 = OptimizationProblems.ADNLPProblems.woods(n=12, type=Val(Float16))
```

```plaintext
ADNLPModel - Model with automatic differentiation backend ADNLPModels.ADMod
elBackend{ADNLPModels.ForwardDiffADGradient, ADNLPModels.ForwardDiffADHvpro
d, ADNLPModels.ForwardDiffADJprod, ADNLPModels.ForwardDiffADJtprod, ADNLPMo
dels.ForwardDiffADJacobian, ADNLPModels.ForwardDiffADHessian, ADNLPModels.F
orwardDiffADGHjvprod}(ADNLPModels.ForwardDiffADGradient(ForwardDiff.Gradien
tConfig{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Flo
at16}, Float16}, Float16, 12, Vector{ForwardDiff.Dual{ForwardDiff.Tag{Optim
izationProblems.ADNLPProblems.var"#f#1329"{Float16}, Float16}, Float16, 12}
}}((Partials(Float16(1.0), Float16(0.0), Float16(0.0), Float16(0.0), Float1
6(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0
), Float16(0.0), Float16(0.0)), Partials(Float16(0.0), Float16(1.0), Float1
6(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0
), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0)), Partials(Float1
6(0.0), Float16(0.0), Float16(1.0), Float16(0.0), Float16(0.0), Float16(0.0
), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Fl
oat16(0.0)), Partials(Float16(0.0), Float16(0.0), Float16(0.0), Float16(1.0
), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Fl
oat16(0.0), Float16(0.0), Float16(0.0)), Partials(Float16(0.0), Float16(0.0
), Float16(0.0), Float16(0.0), Float16(1.0), Float16(0.0), Float16(0.0), Fl
oat16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0)), Partia
ls(Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Fl
oat16(1.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16
(0.0), Float16(0.0)), Partials(Float16(0.0), Float16(0.0), Float16(0.0), Fl
oat16(0.0), Float16(0.0), Float16(0.0), Float16(1.0), Float16(0.0), Float16
(0.0), Float16(0.0), Float16(0.0), Float16(0.0)), Partials(Float16(0.0), Fl
oat16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16
(0.0), Float16(1.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0)
), Partials(Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16
(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(1.0), Float16(0.0)
, Float16(0.0), Float16(0.0)), Partials(Float16(0.0), Float16(0.0), Float16
(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0)
, Float16(0.0), Float16(1.0), Float16(0.0), Float16(0.0)), Partials(Float16
(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0)
, Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(1.0), Flo
at16(0.0)), Partials(Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0)
, Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Float16(0.0), Flo
at16(0.0), Float16(0.0), Float16(1.0))), ForwardDiff.Dual{ForwardDiff.Tag{O
ptimizationProblems.ADNLPProblems.var"#f#1329"{Float16}, Float16}, Float16,
 12}[Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{F
loat16}, Float16}}(0.0,0.0,0.0,0.0,6.0e-8,0.0,0.0,0.0,6.0e-8,0.0,0.0,0.0,6.
0e-8), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"
{Float16}, Float16}}(0.0,0.0,0.0,6.0e-8,0.0,0.0,0.0,6.0e-8,0.0,0.0,0.0,6.0e
-8,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#132
9"{Float16}, Float16}}(0.0,0.0,6.0e-8,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0
.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{F
loat16}, Float16}}(0.0,6.0e-8,0.0,0.0,0.0,6.0e-8,0.0,0.0,0.0,0.0,0.0,0.0,0.
0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Fl
oat16}, Float16}}(0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0e-7,0.0,0.0,0.0,6.0e-8
), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Flo
at16}, Float16}}(0.0,0.0,0.0,6.0e-8,0.0,0.0,0.0,1.0e-7,0.0,0.0,0.0,6.0e-8,0
.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{F
loat16}, Float16}}(0.0,0.0,6.0e-8,0.0,0.0,0.0,6.0e-8,0.0,0.0,0.0,6.0e-8,0.0
,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"
{Float16}, Float16}}(0.0,6.0e-8,0.0,0.0,0.0,6.0e-8,0.0,0.0,0.0,6.0e-8,0.0,0
.0,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#132
9"{Float16}, Float16}}(6.0e-8,0.0,0.0,0.0,1.0e-7,0.0,0.0,0.0,6.0e-8,0.0,0.0
,0.0,6.0e-8), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#
f#1329"{Float16}, Float16}}(0.0,0.0,0.0,6.0e-8,0.0,0.0,0.0,6.0e-8,0.0,0.0,0
.0,6.0e-8,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var
"#f#1329"{Float16}, Float16}}(0.0,0.0,6.0e-8,0.0,0.0,0.0,6.0e-8,0.0,0.0,0.0
,0.0,0.0,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"
#f#1329"{Float16}, Float16}}(0.0,-3.406,-0.002157,NaN,0.0,6.656e3,-0.002163
,NaN,0.0,-3.406,-0.002157,NaN,0.0)])), ADNLPModels.ForwardDiffADHvprod(), A
DNLPModels.ForwardDiffADJprod(), ADNLPModels.ForwardDiffADJtprod(), ADNLPMo
dels.ForwardDiffADJacobian(0), ADNLPModels.ForwardDiffADHessian(78), ADNLPM
odels.ForwardDiffADGHjvprod())
  Problem name: woods
   All variables: ████████████████████ 12     All constraints: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            free: ████████████████████ 12                free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
         low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0              low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
           fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
          infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0               infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: (  0.00% sparsity)   78              linear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                    nonlinear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅
⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                         nnzj: (------% spa
rsity)         

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




Then, all the API will be compatible with the precised type.
```julia
using NLPModels
obj(nlp16_12, zeros(Float16, 12))
```

```plaintext
Error: ArgumentError: Package NLPModels not found in current path:
- Run `import Pkg; Pkg.add("NLPModels")` to install the NLPModels package.
```


