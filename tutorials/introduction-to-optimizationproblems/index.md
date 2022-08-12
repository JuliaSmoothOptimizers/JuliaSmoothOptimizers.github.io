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
Error: ArgumentError: Package NLPModelsJuMP not found in current path:
- Run `import Pkg; Pkg.add("NLPModelsJuMP")` to install the NLPModelsJuMP p
ackage.
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
roblems.ADNLPProblems.var"#f#1332"{Float64}, Float64}}(0.0,0.0,0.0,0.0), Du
al{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1332"{Float64}
, Float64}}(0.0,0.0,0.0,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADN
LPProblems.var"#f#1332"{Float64}, Float64}}(0.0,0.0,0.0,0.0)])), ADNLPModel
s.ForwardDiffADHvprod(), ADNLPModels.ForwardDiffADJprod(), ADNLPModels.Forw
ardDiffADJtprod(), ADNLPModels.ForwardDiffADJacobian(9), ADNLPModels.Forwar
dDiffADHessian(6), ADNLPModels.ForwardDiffADGHjvprod())
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
.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(2.
1219957915e-314,3.8195924245e-313,2.5463949502e-313,5.304989478e-313,6.5781
869534e-313,4.6683907412e-313,4.6683907412e-313,4.66839074175e-313,2.546394
9509e-313,8.912382324e-313,7.6391848497e-313,7.63918484925e-313,9.973380219
3e-313), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#132
9"{Float64}, Float64}}(1.06099789566e-312,2.5463949517e-313,2.33419537065e-
313,2.3341953706e-313,2.3341953706e-313,2.3341953706e-313,4.243991582e-314,
1.10343781131e-312,4.2439916076e-314,1.12465776922e-312,4.243991608e-314,1.
14587772713e-312,4.2439916086e-314), Dual{ForwardDiff.Tag{OptimizationProbl
ems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(1.16709768504e-312,4.243
991609e-314,1.18831764295e-312,4.2439916096e-314,1.20953760086e-312,4.24399
161e-314,6.9033212082815e-310,6.90332120828465e-310,6.9033212082878e-310,6.
903321208291e-310,6.90332120829414e-310,6.9033212082973e-310,6.903321208300
46e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#13
29"{Float64}, Float64}}(6.90332120830363e-310,6.9033212083068e-310,6.903321
20830995e-310,6.9033212083131e-310,6.90332120831627e-310,6.90332120831944e-
310,6.9033212083226e-310,6.90332120832576e-310,6.9033212083289e-310,6.90332
12083321e-310,6.90332120833525e-310,6.9033212083384e-310,6.90332120834157e-
310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{
Float64}, Float64}}(6.90332120834473e-310,6.9033212083479e-310,6.9033212083
5106e-310,6.9033212083542e-310,6.9033212083574e-310,6.90332120836054e-310,6
.9033212083637e-310,6.90332120836687e-310,6.90332120837003e-310,6.903321208
17517e-310,6.9033212083732e-310,6.90332120817517e-310,6.90332120837635e-310
), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Flo
at64}, Float64}}(6.90332120838584e-310,6.90332120817517e-310,6.903321208205
6e-310,6.903321208389e-310,6.90332120839216e-310,6.90332120817517e-310,6.90
33212083795e-310,6.90332120817517e-310,6.9033212083795e-310,6.9033212081751
7e-310,6.9033212083827e-310,6.90332120817517e-310,6.9033212083827e-310), Du
al{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}
, Float64}}(6.90332120817517e-310,6.9033212082056e-310,6.9033212083953e-310
,6.90332120817517e-310,6.90332120840165e-310,6.9033212084048e-310,6.9033212
0840797e-310,6.90332120841113e-310,6.9033212084143e-310,6.90332120841746e-3
10,6.9033212084206e-310,6.9033212084238e-310,6.90332120842694e-310), Dual{F
orwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Fl
oat64}}(6.9033212084301e-310,6.90332120843327e-310,6.90332120843643e-310,6.
9033212084396e-310,6.90332120844275e-310,6.9033212084459e-310,6.90332120844
91e-310,6.90332120845224e-310,6.9033212084554e-310,6.90332120845856e-310,6.
90332120846173e-310,6.9033212084649e-310,6.90332120846805e-310), Dual{Forwa
rdDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float6
4}}(6.9033212084712e-310,6.90332120847437e-310,6.90332120847754e-310,6.9033
212084807e-310,6.90332120848386e-310,6.903321208487e-310,6.9033212084902e-3
10,6.90332120849335e-310,6.9033212084965e-310,6.90332120849967e-310,6.90332
120850283e-310,6.903321208506e-310,6.90332120850916e-310), Dual{ForwardDiff
.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.
9033212085123e-310,6.9033212085155e-310,6.90332120851864e-310,6.90332120852
18e-310,6.90332120852497e-310,6.90332120852813e-310,6.9033212085313e-310,6.
90332120853445e-310,6.9033212085376e-310,6.9033212085408e-310,6.90332120854
394e-310,6.9033212085471e-310,6.90332120855026e-310), Dual{ForwardDiff.Tag{
OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.90332
120855342e-310,6.9033212085566e-310,6.90332120855975e-310,6.9033212085629e-
310,6.90332120856607e-310,6.90332120856924e-310,6.9033212085724e-310,6.9033
2120857556e-310,6.9033212085787e-310,6.9033212085819e-310,6.90332120858505e
-310,6.9033212085882e-310,6.90332120859137e-310), Dual{ForwardDiff.Tag{Opti
mizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.903321208
59453e-310,6.9033212085977e-310,6.90332120860086e-310,6.903321208604e-310,6
.9033212086072e-310,6.90332120861034e-310,6.9033212086135e-310,6.9033212086
1667e-310,6.90332120837635e-310,6.9033212083795e-310,6.9033212083827e-310,0
.0,0.0)])), ADNLPModels.ForwardDiffADHvprod(), ADNLPModels.ForwardDiffADJpr
od(), ADNLPModels.ForwardDiffADJtprod(), ADNLPModels.ForwardDiffADJacobian(
0), ADNLPModels.ForwardDiffADHessian(78), ADNLPModels.ForwardDiffADGHjvprod
())
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
.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.
0,6.3966703e-316,6.903326239131e-310,3.8341764e-316,6.3966794e-316,6.544963
5e-316,3.56856976e-316,6.39668056e-316,6.903326239131e-310,3.83357165e-316,
0.0,6.59488626e-316,3.56856976e-316), Dual{ForwardDiff.Tag{OptimizationProb
lems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(5.56596175e-316,6.90332
6239131e-310,3.8341835e-316,0.0,1.5965996e-316,3.56856976e-316,5.51260977e-
316,6.903326239131e-310,1.0e-323,0.0,NaN,0.0,2.22944316e-316), Dual{Forward
Diff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}
}(6.903326239131e-310,3.833574e-316,5.48824127e-316,7.5700181e-316,3.568569
76e-316,5.48824246e-316,6.903326239131e-310,3.8341906e-316,5.5125572e-316,5
.48627687e-316,3.56856976e-316,5.5125584e-316,6.903326239131e-310), Dual{Fo
rwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Flo
at64}}(3.8335835e-316,0.0,1.7526548e-316,3.56856976e-316,6.44386265e-316,6.
903326239131e-310,3.8335859e-316,0.0,2.7745794e-316,3.56856976e-316,5.56610
09e-316,6.903326239131e-310,3.8335906e-316), Dual{ForwardDiff.Tag{Optimizat
ionProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.75645956e-316,
6.5948926e-316,3.56856976e-316,6.75646075e-316,6.903326239131e-310,3.834197
73e-316,0.0,3.651738e-316,3.56856976e-316,3.58475535e-316,6.903326239131e-3
10,1.0e-323,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.v
ar"#f#1329"{Float64}, Float64}}(NaN,0.0,0.0,6.903326239131e-310,3.83359774e
-316,4.08117e-316,9.8787497e-316,3.56856976e-316,4.08117117e-316,6.90332623
9131e-310,3.8336001e-316,0.0,1.7526524e-316), Dual{ForwardDiff.Tag{Optimiza
tionProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.56856976e-316
,6.4438516e-316,6.903326239131e-310,3.8336025e-316,0.0,7.3544517e-316,3.568
56976e-316,9.851099e-316,6.903326239131e-310,3.83421196e-316,0.0,1.7286369e
-316,3.56856976e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProbl
ems.var"#f#1329"{Float64}, Float64}}(5.51255365e-316,6.903326239131e-310,1.
0e-323,0.0,NaN,0.0,0.0,6.903326239131e-310,3.8342167e-316,0.0,2.1585222e-31
6,3.56856976e-316,9.85106345e-316), Dual{ForwardDiff.Tag{OptimizationProble
ms.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.903326239131e-310,3.833
61196e-316,4.0810759e-316,2.8514386e-316,3.56856976e-316,4.0810771e-316,6.9
03326239131e-310,3.83476215e-316,6.75640423e-316,4.5738906e-316,3.56856976e
-316,6.7564054e-316,6.903326239131e-310), Dual{ForwardDiff.Tag{Optimization
Problems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.8336167e-316,5.51
256195e-316,9.8787434e-316,3.56856976e-316,5.51256313e-316,6.903326239131e-
310,6.95258723262955e-310,2.81605363e-316,NaN,0.0,2.8160548e-316,6.90332623
9131e-310,6.95258723262955e-310), Dual{ForwardDiff.Tag{OptimizationProblems
.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,NaN,0.0,5.5661317e-316,
6.903326239131e-310,3.8336238e-316,6.15938637e-316,4.3438307e-316,3.5685697
6e-316,6.15938755e-316,6.903326239131e-310,3.8342096e-316,0.0), Dual{Forwar
dDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64
}}(3.6517467e-316,3.56856976e-316,6.5450987e-316,6.903326239131e-310,3.8342
3567e-316,9.8510528e-316,2.15852854e-316,3.56856976e-316,9.85105397e-316,6.
903326239131e-310,3.83423804e-316,5.48821677e-316,9.3019933e-316), Dual{For
wardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Floa
t64}}(3.56856976e-316,5.48821795e-316,6.903326239131e-310,6.95258723262955e
-310,0.0,NaN,0.0,2.8160493e-316,6.903326239131e-310,3.8342428e-316,3.584794
5e-316,3.42862665e-316,3.56856976e-316), Dual{ForwardDiff.Tag{OptimizationP
roblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.58479566e-316,6.90
3326239131e-310,3.8336357e-316,0.0,4.34382516e-316,3.56856976e-316,6.159392
3e-316,6.903326239131e-310,3.8336404e-316,0.0,2.8514742e-316,3.56856976e-31
6,3.1465784e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.
var"#f#1329"{Float64}, Float64}}(6.903326239131e-310,3.8336428e-316,3.58462
294e-316,3.95147656e-316,3.56856976e-316,3.5846241e-316,6.903326239131e-310
,3.83424516e-316,2.8161572e-316,3.1277948e-316,3.56856976e-316,2.81615837e-
316,6.903326239131e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPr
oblems.var"#f#1329"{Float64}, Float64}}(3.83364754e-316,5.5126726e-316,5.19
40497e-316,3.56856976e-316,5.5126738e-316,6.903326239131e-310,3.83425465e-3
16,0.0,6.26255953e-316,3.56856976e-316,3.5847498e-316,6.903326239131e-310,3
.8336523e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var
"#f#1329"{Float64}, Float64}}(0.0,7.47521006e-316,3.56856976e-316,6.4438587
e-316,6.903326239131e-310,3.834257e-316,0.0,3.1077389e-316,3.56856976e-316,
7.9498791e-316,6.903326239131e-310,3.833657e-316,9.8511421e-316), Dual{Forw
ardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float
64}}(3.1367789e-316,3.56856976e-316,9.8511433e-316,6.903326239131e-310,3.83
36594e-316,3.146544e-316,5.1940552e-316,3.56856976e-316,3.1465452e-316,6.90
3326239131e-310,3.83426887e-316,0.0,3.2063461e-316), Dual{ForwardDiff.Tag{O
ptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.568569
76e-316,5.51271096e-316,6.903326239131e-310,3.83366177e-316,3.1465725e-316,
2.8514797e-316,3.56856976e-316,3.14657367e-316,6.903326239131e-310,3.834273
6e-316,3.58473677e-316,6.26256585e-316,3.56856976e-316), Dual{ForwardDiff.T
ag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.58
473796e-316,6.903326239131e-310,3.8336689e-316,9.85119744e-316,3.13678563e-
316,3.56856976e-316,9.85119863e-316,6.903326239131e-310,3.83427836e-316,9.8
511089e-316,7.35462603e-316,3.56856976e-316,9.8511101e-316), Dual{ForwardDi
ff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(
6.903326239131e-310,3.83428073e-316,0.0,5.1942564e-316,3.56856976e-316,5.51
267855e-316,6.903326239131e-310,3.83427125e-316,6.15933973e-316,4.4935713e-
316,3.56856976e-316,6.1593409e-316,6.903326239131e-310), Dual{ForwardDiff.T
ag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.83
428548e-316,6.1593603e-316,4.49357685e-316,3.56856976e-316,6.15936147e-316,
6.903326239131e-310,6.95258723262955e-310,6.15929467e-316,NaN,0.0,6.1592958
6e-316,6.903326239131e-310,3.8336831e-316), Dual{ForwardDiff.Tag{Optimizati
onProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,1.7284013e-31
6,3.56856976e-316,5.5127141e-316,6.903326239131e-310,3.8336855e-316,5.51258
487e-316,3.9514655e-316,3.56856976e-316,5.51258606e-316,6.903326239131e-310
,3.83368785e-316,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProbl
ems.var"#f#1329"{Float64}, Float64}}(7.85954175e-316,3.56856976e-316,5.4883
0807e-316,6.903326239131e-310,3.83429496e-316,6.15935e-316,3.2063548e-316,3
.56856976e-316,6.1593512e-316,6.903326239131e-310,3.8342997e-316,0.0,6.2625
5083e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#
1329"{Float64}, Float64}}(3.56856976e-316,3.58475535e-316,6.903326239131e-3
10,3.83369497e-316,0.0,5.91473257e-316,3.56856976e-316,6.3966442e-316,6.903
326239131e-310,3.83369734e-316,0.0,6.59487757e-316,3.56856976e-316), Dual{F
orwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Fl
oat64}}(3.58475535e-316,6.903326239131e-310,3.8342831e-316,2.81604335e-316,
7.4290011e-316,3.56856976e-316,2.81604454e-316,6.903326239131e-310,6.952587
23265248e-310,6.75639474e-316,NaN,0.0,6.75639593e-316), Dual{ForwardDiff.Ta
g{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.903
326239131e-310,3.83431156e-316,0.0,6.5946839e-316,3.56856976e-316,5.5660123
4e-316,6.903326239131e-310,3.83366414e-316,5.56603645e-316,5.56750403e-316,
3.56856976e-316,5.56603764e-316,6.903326239131e-310), Dual{ForwardDiff.Tag{
OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.83370
92e-316,3.58475416e-316,3.2061651e-316,3.56856976e-316,3.58475535e-316,6.90
3326239131e-310,3.833676e-316,5.5660894e-316,6.5184634e-316,3.56856976e-316
,5.5660906e-316,6.903326239131e-310,3.83432105e-316), Dual{ForwardDiff.Tag{
OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(5.51259
83e-316,3.75572854e-316,3.56856976e-316,5.5125995e-316,6.903326239131e-310,
3.8343234e-316,0.0,2.8516046e-316,3.56856976e-316,4.0810866e-316,6.90332623
9131e-310,3.8337187e-316,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.AD
NLPProblems.var"#f#1329"{Float64}, Float64}}(2.2411031e-316,3.56856976e-316
,7.94984825e-316,6.903326239131e-310,3.83372105e-316,3.1466144e-316,3.97275
814e-316,3.56856976e-316,3.14661556e-316,6.903326239131e-310,3.83372343e-31
6,0.0,4.34376113e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProb
lems.var"#f#1329"{Float64}, Float64}}(3.56856976e-316,3.1465523e-316,6.9033
26239131e-310,3.83433053e-316,7.9498028e-316,3.62285453e-316,3.56856976e-31
6,7.949804e-316,6.903326239131e-310,3.8343353e-316,7.94980754e-316,3.691898
4e-316,3.56856976e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPro
blems.var"#f#1329"{Float64}, Float64}}(7.94980873e-316,6.903326239131e-310,
3.83433765e-316,5.56600167e-316,3.6267201e-316,3.56856976e-316,5.56600286e-
316,6.903326239131e-310,3.83434e-316,5.5125896e-316,3.75570997e-316,3.56856
976e-316,5.5125908e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPr
oblems.var"#f#1329"{Float64}, Float64}}(6.903326239131e-310,3.834276e-316,5
.48822625e-316,8.03939706e-316,3.56856976e-316,5.48822744e-316,6.9033262391
31e-310,6.95258723262955e-310,5.51251847e-316,NaN,0.0,5.51251966e-316,6.903
326239131e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.va
r"#f#1329"{Float64}, Float64}}(3.8337258e-316,0.0,2.15869533e-316,3.5685697
6e-316,7.94989964e-316,6.903326239131e-310,3.8337424e-316,6.1593911e-316,4.
34376745e-316,3.56856976e-316,6.1593923e-316,6.903326239131e-310,3.8343519e
-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"
{Float64}, Float64}}(0.0,3.7557155e-316,3.56856976e-316,5.51259476e-316,6.9
03326239131e-310,3.83434713e-316,2.81615244e-316,3.75488507e-316,3.56856976
e-316,2.81615363e-316,6.903326239131e-310,3.83372817e-316,6.39663906e-316),
 Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float
64}, Float64}}(4.36339174e-316,3.56856976e-316,6.39664025e-316,6.9033262391
31e-310,3.83422856e-316,6.545088e-316,3.651753e-316,3.56856976e-316,6.54508
92e-316,6.903326239131e-310,3.83375426e-316,3.14653137e-316,5.91426143e-316
), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Flo
at64}, Float64}}(3.56856976e-316,3.14653256e-316,6.903326239131e-310,3.8343
6374e-316,0.0,2.85159276e-316,3.56856976e-316,4.0810866e-316,6.903326239131
e-310,3.83375663e-316,7.9498178e-316,3.7003667e-316,3.56856976e-316), Dual{
ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, F
loat64}}(7.949819e-316,6.903326239131e-310,3.833759e-316,5.4883069e-316,5.9
142634e-316,3.56856976e-316,5.48830807e-316,6.903326239131e-310,1.0e-323,0.
0,NaN,0.0,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var
"#f#1329"{Float64}, Float64}}(6.903326239131e-310,3.8343732e-316,6.44378795
e-316,3.8559729e-316,3.56856976e-316,6.44378913e-316,6.903326239131e-310,6.
95258723262955e-310,3.0493214e-316,NaN,0.0,3.04932257e-316,6.903326239131e-
310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{
Float64}, Float64}}(6.95258723262955e-310,3.0493214e-316,NaN,0.0,3.04932257
e-316,6.903326239131e-310,3.83438034e-316,0.0,2.85158564e-316,3.56856976e-3
16,4.08108184e-316,6.903326239131e-310,3.83369022e-316), Dual{ForwardDiff.T
ag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,
5.4142164e-316,3.56856976e-316,5.4882567e-316,6.903326239131e-310,3.8343827
e-316,0.0,4.11888774e-316,3.56856976e-316,5.48826696e-316,6.903326239131e-3
10,3.83377323e-316,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPro
blems.var"#f#1329"{Float64}, Float64}}(4.25767355e-316,3.56856976e-316,7.94
983323e-316,6.903326239131e-310,3.8343898e-316,0.0,2.2768142e-316,3.5685697
6e-316,2.8160801e-316,6.903326239131e-310,6.95258723262955e-310,4.08114626e
-316,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1
329"{Float64}, Float64}}(0.0,4.08114745e-316,6.903326239131e-310,3.8337851e
-316,0.0,5.5127584e-316,3.56856976e-316,6.15935593e-316,6.903326239131e-310
,3.83378983e-316,5.56608467e-316,6.51847368e-316,3.56856976e-316), Dual{For
wardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Floa
t64}}(5.56608586e-316,6.903326239131e-310,3.8337922e-316,0.0,1.7497497e-316
,3.56856976e-316,5.5126825e-316,6.903326239131e-310,1.0e-323,0.0,NaN,0.0,0.
0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Fl
oat64}, Float64}}(6.903326239131e-310,3.83439694e-316,7.94979806e-316,4.021
5564e-316,3.56856976e-316,7.94979924e-316,6.903326239131e-310,3.83379694e-3
16,6.3966343e-316,4.847748e-316,3.56856976e-316,6.3966355e-316,6.9033262391
31e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#13
29"{Float64}, Float64}}(3.8337661e-316,7.94988817e-316,5.9142654e-316,3.568
56976e-316,7.94988936e-316,6.903326239131e-310,3.8344088e-316,6.39667464e-3
16,7.3546707e-316,3.56856976e-316,6.3966758e-316,6.903326239131e-310,3.8337
993e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1
329"{Float64}, Float64}}(0.0,3.65186685e-316,3.56856976e-316,6.5451896e-316
,6.903326239131e-310,3.8344159e-316,0.0,2.1585135e-316,3.56856976e-316,3.58
475535e-316,6.903326239131e-310,3.83440405e-316,0.0), Dual{ForwardDiff.Tag{
OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.54498
68e-316,3.56856976e-316,6.39676673e-316,6.903326239131e-310,3.83370683e-316
,0.0,3.6519198e-316,3.56856976e-316,5.48831835e-316,6.903326239131e-310,3.8
338159e-316,0.0,4.2576617e-316), Dual{ForwardDiff.Tag{OptimizationProblems.
ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.56856976e-316,7.94983323e-
316,6.903326239131e-310,3.8338183e-316,0.0,6.59481947e-316,3.56856976e-316,
5.56607637e-316,6.903326239131e-310,3.83441354e-316,6.6088201e-316,5.567712
7e-316,3.56856976e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPro
blems.var"#f#1329"{Float64}, Float64}}(6.6088213e-316,6.903326239131e-310,3
.8344183e-316,6.54521844e-316,2.2768442e-316,3.56856976e-316,6.5452196e-316
,6.903326239131e-310,3.8338254e-316,6.7563995e-316,4.3437896e-316,3.5685697
6e-316,6.75640067e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPro
blems.var"#f#1329"{Float64}, Float64}}(6.903326239131e-310,6.95258723262955
e-310,4.081151e-316,NaN,0.0,4.0811522e-316,6.903326239131e-310,3.83383014e-
316,6.3967205e-316,5.56754434e-316,3.56856976e-316,6.39672167e-316,6.903326
239131e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#
f#1329"{Float64}, Float64}}(3.8338325e-316,0.0,4.2576546e-316,3.56856976e-3
16,7.9498285e-316,6.903326239131e-310,3.8338349e-316,6.6088612e-316,3.42875
076e-316,3.56856976e-316,6.6088624e-316,6.903326239131e-310,3.83383726e-316
), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Flo
at64}, Float64}}(0.0,4.2468697e-316,3.56856976e-316,7.949838e-316,6.9033262
39131e-310,3.83383963e-316,0.0,3.1367398e-316,3.56856976e-316,3.04922455e-3
16,6.903326239131e-310,3.833842e-316,0.0), Dual{ForwardDiff.Tag{Optimizatio
nProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.65187397e-316,3.
56856976e-316,6.5451793e-316,6.903326239131e-310,3.8342665e-316,5.4882215e-
316,3.13072404e-316,3.56856976e-316,5.4882227e-316,6.903326239131e-310,1.0e
-323,0.0,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"
#f#1329"{Float64}, Float64}}(0.0,0.0,6.903326239131e-310,3.8344562e-316,0.0
,2.85161173e-316,3.56856976e-316,4.0810945e-316,6.903326239131e-310,3.83445
86e-316,0.0,7.5359912e-316,3.56856976e-316), Dual{ForwardDiff.Tag{Optimizat
ionProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(5.5127007e-316,6
.903326239131e-310,3.8338515e-316,7.9498273e-316,4.25764825e-316,3.56856976
e-316,7.9498285e-316,6.903326239131e-310,3.83385623e-316,3.1465772e-316,2.8
514165e-316,3.56856976e-316,3.1465784e-316), Dual{ForwardDiff.Tag{Optimizat
ionProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.903326239131e-
310,6.95258723254734e-310,0.0,NaN,0.0,5.4882322e-316,6.903326239131e-310,6.
952587232643e-310,2.8160742e-316,NaN,0.0,2.81607537e-316,6.903326239131e-31
0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Fl
oat64}, Float64}}(3.83446334e-316,3.731596e-316,7.3554513e-316,3.56856976e-
316,3.7315972e-316,6.903326239131e-310,6.95258723262955e-310,5.51257144e-31
6,NaN,0.0,5.5125726e-316,6.903326239131e-310,1.0e-323), Dual{ForwardDiff.Ta
g{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,N
aN,0.0,0.0,6.903326239131e-310,1.0e-323,0.0,NaN,0.0,0.0,6.903326239131e-310
,1.0e-323,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var
"#f#1329"{Float64}, Float64}}(NaN,0.0,2.2294582e-316,6.903326239131e-310,3.
833593e-316,5.48830214e-316,7.8595473e-316,3.56856976e-316,5.48830333e-316,
6.903326239131e-310,3.83387757e-316,5.4881646e-316,3.65184156e-316), Dual{F
orwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Fl
oat64}}(3.56856976e-316,5.4881658e-316,6.903326239131e-310,1.0e-323,0.0,NaN
,0.0,0.0,6.903326239131e-310,3.8338823e-316,0.0,7.9171087e-316,3.56856976e-
316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{
Float64}, Float64}}(3.7316059e-316,6.903326239131e-310,1.0e-323,0.0,NaN,0.0
,0.0,6.903326239131e-310,3.83449417e-316,0.0,6.54485125e-316,3.56856976e-31
6,6.3967264e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.
var"#f#1329"{Float64}, Float64}}(6.903326239131e-310,3.83388943e-316,0.0,7.
5356505e-316,3.56856976e-316,3.58462887e-316,6.903326239131e-310,3.8338918e
-316,0.0,4.3437141e-316,3.56856976e-316,6.15934566e-316,6.903326239131e-310
), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Flo
at64}, Float64}}(3.8345013e-316,5.51253665e-316,8.2713996e-316,3.56856976e-
316,5.51253784e-316,6.903326239131e-310,3.83450365e-316,0.0,4.573904e-316,3
.56856976e-316,6.75641016e-316,6.903326239131e-310,3.8344823e-316), Dual{Fo
rwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Flo
at64}}(6.60881536e-316,6.51122237e-316,3.56856976e-316,6.60881654e-316,6.90
3326239131e-310,3.8345084e-316,0.0,5.56764157e-316,3.56856976e-316,6.608811
e-316,6.903326239131e-310,6.95258723262955e-310,0.0), Dual{ForwardDiff.Tag{
OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(NaN,0.0
,9.8511599e-316,6.903326239131e-310,3.83390603e-316,0.0,6.5450536e-316,3.56
856976e-316,6.3966853e-316,6.903326239131e-310,3.8339084e-316,0.0,1.5975284
6e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#132
9"{Float64}, Float64}}(3.56856976e-316,5.5125149e-316,6.903326239131e-310,3
.8345179e-316,0.0,8.27140515e-316,3.56856976e-316,5.5125418e-316,6.90332623
9131e-310,3.83452026e-316,0.0,4.573923e-316,3.56856976e-316), Dual{ForwardD
iff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}
(6.7564149e-316,6.903326239131e-310,3.83452263e-316,5.51270503e-316,5.05396
666e-316,3.56856976e-316,5.5127062e-316,6.903326239131e-310,1.0e-323,0.0,Na
N,0.0,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#
1329"{Float64}, Float64}}(6.903326239131e-310,3.83392026e-316,0.0,4.4941009
6e-316,3.56856976e-316,5.56609535e-316,6.903326239131e-310,3.83392263e-316,
0.0,2.2768691e-316,3.56856976e-316,6.5450734e-316,6.903326239131e-310), Dua
l{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64},
 Float64}}(6.95258723262955e-310,0.0,NaN,0.0,5.4881705e-316,6.903326239131e
-310,3.8339274e-316,6.54517417e-316,2.27685805e-316,3.56856976e-316,6.54517
535e-316,6.903326239131e-310,3.83453686e-316), Dual{ForwardDiff.Tag{Optimiz
ationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,4.5739159e
-316,3.56856976e-316,6.75641016e-316,6.903326239131e-310,3.8339321e-316,0.0
,3.19289963e-316,3.56856976e-316,6.44386976e-316,6.903326239131e-310,3.8339
345e-316,2.2295313e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPr
oblems.var"#f#1329"{Float64}, Float64}}(4.34372516e-316,3.56856976e-316,2.2
295325e-316,6.903326239131e-310,1.0e-323,0.0,NaN,0.0,3.04923957e-316,6.9033
26239131e-310,3.83454634e-316,6.1594259e-316,4.4935065e-316), Dual{ForwardD
iff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}
(3.56856976e-316,6.1594271e-316,6.903326239131e-310,3.83391315e-316,6.54514
413e-316,7.53567065e-316,3.56856976e-316,6.5451453e-316,6.903326239131e-310
,3.83452737e-316,0.0,6.51120735e-316,3.56856976e-316), Dual{ForwardDiff.Tag
{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.5847
5535e-316,6.903326239131e-310,3.83394635e-316,5.56599693e-316,7.91712925e-3
16,3.56856976e-316,5.5659981e-316,6.903326239131e-310,3.83455583e-316,0.0,4
.2470112e-316,3.56856976e-316,6.54508366e-316), Dual{ForwardDiff.Tag{Optimi
zationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.90332623913
1e-310,3.8345582e-316,5.51254535e-316,8.2714182e-316,3.56856976e-316,5.5125
4653e-316,6.903326239131e-310,3.83456057e-316,0.0,3.4287065e-316,3.56856976
e-316,2.2294487e-316,6.903326239131e-310), Dual{ForwardDiff.Tag{Optimizatio
nProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.83453923e-316,0.
0,6.51121605e-316,3.56856976e-316,6.60882603e-316,6.903326239131e-310,3.833
9582e-316,0.0,6.5450449e-316,3.56856976e-316,3.58475535e-316,6.903326239131
e-310,1.0e-323), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.va
r"#f#1329"{Float64}, Float64}}(0.0,NaN,0.0,0.0,6.903326239131e-310,3.834570
06e-316,0.0,7.0802935e-316,3.56856976e-316,6.54513425e-316,6.903326239131e-
310,3.8339653e-316,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPro
blems.var"#f#1329"{Float64}, Float64}}(2.02100833e-316,3.56856976e-316,9.85
113855e-316,6.903326239131e-310,6.95258723254734e-310,0.0,NaN,0.0,7.9498134
7e-316,6.903326239131e-310,1.0e-323,0.0,NaN), Dual{ForwardDiff.Tag{Optimiza
tionProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,2.22951826e
-316,6.903326239131e-310,1.0e-323,0.0,NaN,0.0,0.0,6.903326239131e-310,1.0e-
323,0.0,NaN,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.v
ar"#f#1329"{Float64}, Float64}}(0.0,6.903326239131e-310,1.0e-323,0.0,NaN,0.
0,0.0,6.903326239131e-310,3.83397955e-316,4.08108065e-316,2.8515793e-316,3.
56856976e-316,4.08108184e-316), Dual{ForwardDiff.Tag{OptimizationProblems.A
DNLPProblems.var"#f#1329"{Float64}, Float64}}(6.903326239131e-310,6.9525872
3262955e-310,3.58466246e-316,NaN,0.0,3.58466365e-316,6.903326239131e-310,3.
8345914e-316,5.5659558e-316,6.59479615e-316,3.56856976e-316,5.565957e-316,6
.903326239131e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblem
s.var"#f#1329"{Float64}, Float64}}(6.95258723262955e-310,0.0,NaN,0.0,3.5847
2215e-316,6.903326239131e-310,1.0e-323,0.0,NaN,0.0,0.0,6.903326239131e-310,
3.8345985e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.va
r"#f#1329"{Float64}, Float64}}(2.10505206e-316,5.5551184e-316,3.56856976e-3
16,2.10505324e-316,6.903326239131e-310,3.8339938e-316,9.8510575e-316,8.2716
3756e-316,3.56856976e-316,9.8510587e-316,6.903326239131e-310,3.8346009e-316
,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"
{Float64}, Float64}}(2.1586495e-316,3.56856976e-316,9.85114724e-316,6.90332
6239131e-310,6.9525872325323e-310,0.0,NaN,0.0,5.48819503e-316,6.90332623913
1e-310,1.0e-323,0.0,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPr
oblems.var"#f#1329"{Float64}, Float64}}(0.0,2.2295088e-316,6.903326239131e-
310,3.83461037e-316,0.0,6.61509197e-316,3.56856976e-316,5.4882978e-316,6.90
3326239131e-310,1.0e-323,0.0,NaN,0.0), Dual{ForwardDiff.Tag{OptimizationPro
blems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,6.903326239131e-31
0,3.834008e-316,4.0811747e-316,9.87881294e-316,3.56856976e-316,4.0811759e-3
16,6.903326239131e-310,3.8346175e-316,0.0,2.27669007e-316,3.56856976e-316,6
.1593773e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var
"#f#1329"{Float64}, Float64}}(6.903326239131e-310,3.83401275e-316,6.5450927
5e-316,7.2625808e-316,3.56856976e-316,6.54509393e-316,6.903326239131e-310,1
.0e-323,0.0,NaN,0.0,3.04918186e-316,6.903326239131e-310), Dual{ForwardDiff.
Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.8
346246e-316,3.0491878e-316,6.2626544e-316,3.56856976e-316,3.049189e-316,6.9
03326239131e-310,1.0e-323,0.0,NaN,0.0,0.0,6.903326239131e-310,6.95258723262
955e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1
329"{Float64}, Float64}}(5.5125667e-316,NaN,0.0,5.5125679e-316,6.9033262391
31e-310,1.0e-323,0.0,NaN,0.0,0.0,6.903326239131e-310,3.8346341e-316,5.51257
62e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#13
29"{Float64}, Float64}}(3.9514469e-316,3.56856976e-316,5.51257736e-316,6.90
3326239131e-310,3.834027e-316,5.51270977e-316,6.5183788e-316,3.56856976e-31
6,5.51271096e-316,6.903326239131e-310,1.0e-323,0.0,NaN), Dual{ForwardDiff.T
ag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,
0.0,6.903326239131e-310,3.83463646e-316,0.0,7.2626804e-316,3.56856976e-316,
3.1465634e-316,6.903326239131e-310,1.0e-323,0.0,NaN,0.0), Dual{ForwardDiff.
Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0
,6.903326239131e-310,3.83464595e-316,3.73160075e-316,6.44600334e-316,3.5685
6976e-316,3.73160193e-316,6.903326239131e-310,3.8340412e-316,0.0,5.474826e-
316,3.56856976e-316,5.48825194e-316), Dual{ForwardDiff.Tag{OptimizationProb
lems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.903326239131e-310,3.8
340436e-316,3.58460397e-316,9.8788019e-316,3.56856976e-316,3.58460515e-316,
6.903326239131e-310,1.0e-323,0.0,NaN,0.0,0.0,6.903326239131e-310), Dual{For
wardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Floa
t64}}(3.83465543e-316,0.0,1.75007933e-316,3.56856976e-316,3.14658157e-316,6
.903326239131e-310,3.8346578e-316,0.0,3.9514398e-316,3.56856976e-316,4.0811
8065e-316,6.903326239131e-310,3.83405307e-316), Dual{ForwardDiff.Tag{Optimi
zationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.5847415e-31
6,6.2624694e-316,3.56856976e-316,3.5847427e-316,6.903326239131e-310,3.83404
83e-316,3.7315802e-316,6.64790306e-316,3.56856976e-316,3.7315814e-316,6.903
326239131e-310,3.8346649e-316,0.0), Dual{ForwardDiff.Tag{OptimizationProble
ms.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.5111603e-316,3.56856976
e-316,6.60880073e-316,6.903326239131e-310,3.8340602e-316,3.58478974e-316,3.
95164454e-316,3.56856976e-316,3.5847909e-316,6.903326239131e-310,3.83466255
e-316,0.0,3.76459366e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLP
Problems.var"#f#1329"{Float64}, Float64}}(3.56856976e-316,3.14653256e-316,6
.903326239131e-310,6.95258723262955e-310,0.0,NaN,0.0,3.5847324e-316,6.90332
6239131e-310,3.8340649e-316,0.0,6.26249273e-316,3.56856976e-316), Dual{Forw
ardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float
64}}(6.44383103e-316,6.903326239131e-310,3.8346744e-316,7.94982256e-316,7.5
355173e-316,3.56856976e-316,7.94982375e-316,6.903326239131e-310,1.0e-323,0.
0,NaN,0.0,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var
"#f#1329"{Float64}, Float64}}(6.903326239131e-310,3.83467678e-316,0.0,1.728
4843e-316,3.56856976e-316,5.51252835e-316,6.903326239131e-310,3.83466017e-3
16,6.44384407e-316,6.46834696e-316,3.56856976e-316,6.44384526e-316,6.903326
239131e-310), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#
f#1329"{Float64}, Float64}}(6.95258723262955e-310,0.0,NaN,0.0,6.3968015e-31
6,6.903326239131e-310,3.83468863e-316,0.0,2.38076796e-316,3.56856976e-316,3
.14653256e-316,6.903326239131e-310,3.8340839e-316), Dual{ForwardDiff.Tag{Op
timizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,6.518
3725e-316,3.56856976e-316,3.14653967e-316,6.903326239131e-310,3.8346934e-31
6,0.0,3.95145245e-316,3.56856976e-316,5.5125813e-316,6.903326239131e-310,3.
83408627e-316,5.51268606e-316), Dual{ForwardDiff.Tag{OptimizationProblems.A
DNLPProblems.var"#f#1329"{Float64}, Float64}}(5.5552425e-316,3.56856976e-31
6,5.51268724e-316,6.903326239131e-310,1.0e-323,0.0,NaN,0.0,2.22949297e-316,
6.903326239131e-310,1.0e-323,0.0,NaN), Dual{ForwardDiff.Tag{OptimizationPro
blems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(0.0,0.0,6.903326239131
e-310,3.83409575e-316,0.0,5.47480703e-316,3.56856976e-316,5.4882472e-316,6.
903326239131e-310,3.8346815e-316,0.0,6.5947179e-316,3.56856976e-316), Dual{
ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, F
loat64}}(5.5660811e-316,6.903326239131e-310,1.0e-323,0.0,NaN,0.0,2.22949297
e-316,6.903326239131e-310,3.83410287e-316,0.0,1.80516093e-316,3.56856976e-3
16,5.5126066e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems
.var"#f#1329"{Float64}, Float64}}(6.903326239131e-310,6.95258723262955e-310
,5.48817487e-316,NaN,0.0,5.48817605e-316,6.903326239131e-310,6.952587232629
55e-310,3.04932613e-316,NaN,0.0,3.0493273e-316,6.903326239131e-310), Dual{F
orwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Fl
oat64}}(3.83410524e-316,3.5846577e-316,7.5356833e-316,3.56856976e-316,3.584
6589e-316,6.903326239131e-310,3.8347171e-316,0.0,6.54488524e-316,3.56856976
e-316,6.39677147e-316,6.903326239131e-310,3.83411473e-316), Dual{ForwardDif
f.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(5
.488246e-316,5.4748007e-316,3.56856976e-316,5.4882472e-316,6.903326239131e-
310,3.8341171e-316,3.58468223e-316,3.8558472e-316,3.56856976e-316,3.5846834
e-316,6.903326239131e-310,3.8347266e-316,4.08116524e-316), Dual{ForwardDiff
.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(3.
12842486e-316,3.56856976e-316,4.0811664e-316,6.903326239131e-310,1.0e-323,0
.0,NaN,0.0,0.0,6.903326239131e-310,3.8347242e-316,0.0,6.3329643e-316), Dual
{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, 
Float64}}(3.56856976e-316,6.44383577e-316,6.903326239131e-310,3.8347337e-31
6,0.0,1.66409926e-316,3.56856976e-316,6.4438484e-316,6.903326239131e-310,1.
0e-323,0.0,NaN,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblem
s.var"#f#1329"{Float64}, Float64}}(0.0,6.903326239131e-310,3.8347313e-316,7
.9497364e-316,2.15861707e-316,3.56856976e-316,7.9497376e-316,6.903326239131
e-310,3.8347408e-316,4.0811605e-316,7.08022276e-316,3.56856976e-316,4.08116
17e-316), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#13
29"{Float64}, Float64}}(6.903326239131e-310,3.8347432e-316,0.0,4.5738969e-3
16,3.56856976e-316,6.7564054e-316,6.903326239131e-310,6.9525872325323e-310,
0.0,NaN,0.0,7.94976683e-316,6.903326239131e-310), Dual{ForwardDiff.Tag{Opti
mizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.952587232
62955e-310,0.0,NaN,0.0,9.85104843e-316,6.903326239131e-310,1.0e-323,0.0,NaN
,0.0,3.0492301e-316,6.903326239131e-310,6.95258723262955e-310), Dual{Forwar
dDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64
}}(0.0,NaN,0.0,2.22941787e-316,6.903326239131e-310,1.0e-323,0.0,NaN,0.0,0.0
,6.903326239131e-310,1.0e-323,0.0), Dual{ForwardDiff.Tag{OptimizationProble
ms.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(NaN,0.0,0.0,6.90332623913
1e-310,3.83415267e-316,0.0,6.4685509e-316,3.56856976e-316,7.94988936e-316,6
.903326239131e-310,3.83415504e-316,2.22941194e-316,7.35475923e-316), Dual{F
orwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Fl
oat64}}(3.56856976e-316,2.22941312e-316,6.903326239131e-310,3.8347645e-316,
6.44383933e-316,6.46835724e-316,3.56856976e-316,6.4438405e-316,6.9033262391
31e-310,3.8347669e-316,0.0,3.16568966e-316,3.56856976e-316), Dual{ForwardDi
ff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(
6.1593662e-316,6.903326239131e-310,3.8341574e-316,0.0,5.47481415e-316,3.568
56976e-316,5.48825194e-316,6.903326239131e-310,6.95258723265248e-310,6.9525
872326769e-310,NaN,0.0,6.15934566e-316), Dual{ForwardDiff.Tag{OptimizationP
roblems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(6.903326239131e-310,
3.8341598e-316,5.48823653e-316,8.271583e-316,3.56856976e-316,5.4882377e-316
,6.903326239131e-310,3.83416927e-316,7.94988343e-316,6.46855644e-316,3.5685
6976e-316,7.9498846e-316,6.079e-320), Dual{ForwardDiff.Tag{OptimizationProb
lems.ADNLPProblems.var"#f#1329"{Float64}, Float64}}(2.22e-321,5.1502794e-31
6,5.5114485e-316,5.5106082e-316,0.0,NaN,0.0,5.0e-324,0.0,6.7508549e-316,0.0
,1.6e-322,9.443317726047391e21), Dual{ForwardDiff.Tag{OptimizationProblems.
ADNLPProblems.var"#f#1329"{Float64}, Float64}}(7.558125123061879e-154,3.398
235778115e-312,7.8551510299e-313,6.75085725e-316,8.487983164e-314,-1.105587
1916232541e-244,-2.986397015342954e-254,1.2989153463666738e287,5.8801323708
32126e137,1.268934864557806e-231,-1.692812158093192e306,3.910462211847e-312
,2.42280991429251e-309), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPPro
blems.var"#f#1329"{Float64}, Float64}}(-1.8370094195097775e282,-9.782954743
948183e26,1.33586203965988e-309,2.736761793400046e44,1.033e-321,6.903327377
96695e-310,6.90332737796695e-310,3.7167341292703204e-268,1.1553676697937789
e48,1.19786786865135e-309,3.79171665626112e-309,-9.277781942621371e-299,7.8
52738716730545e42)])), ADNLPModels.ForwardDiffADHvprod(), ADNLPModels.Forwa
rdDiffADJprod(), ADNLPModels.ForwardDiffADJtprod(), ADNLPModels.ForwardDiff
ADJacobian(0), ADNLPModels.ForwardDiffADHessian(7260), ADNLPModels.ForwardD
iffADGHjvprod())
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
loat16}, Float16}}(-2.344,0.3552,NaN,0.0,-2.469,0.3552,NaN,0.0,-2.594,0.355
2,NaN,0.0,-2.719), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.
var"#f#1329"{Float16}, Float16}}(0.3552,NaN,0.0,-2.844,0.3552,NaN,0.0,-2.96
9,0.3552,NaN,0.0,-3.094,0.3552), Dual{ForwardDiff.Tag{OptimizationProblems.
ADNLPProblems.var"#f#1329"{Float16}, Float16}}(NaN,0.0,-3.219,0.3552,NaN,0.
0,-3.344,0.3552,NaN,0.0,-3.469,0.3552,NaN), Dual{ForwardDiff.Tag{Optimizati
onProblems.ADNLPProblems.var"#f#1329"{Float16}, Float16}}(0.0,-3.594,0.3552
,NaN,0.0,-3.719,0.3552,NaN,0.0,-3.844,0.3552,NaN,0.0), Dual{ForwardDiff.Tag
{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float16}, Float16}}(-3.969
,0.3552,NaN,0.0,-4.188,0.3552,NaN,0.0,-4.438,0.3552,NaN,0.0,-4.688), Dual{F
orwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float16}, Fl
oat16}}(0.3552,NaN,0.0,-4.938,0.3552,NaN,0.0,-5.188,0.3552,NaN,0.0,-5.438,0
.3552), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329
"{Float16}, Float16}}(NaN,0.0,-5.688,0.3552,NaN,0.0,-5.938,0.3552,NaN,0.0,-
6.188,0.3552,NaN), Dual{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.
var"#f#1329"{Float16}, Float16}}(0.0,-6.438,0.3552,NaN,0.0,-6.688,0.3552,Na
N,0.0,-6.938,0.3552,NaN,0.0), Dual{ForwardDiff.Tag{OptimizationProblems.ADN
LPProblems.var"#f#1329"{Float16}, Float16}}(-7.188,0.3552,NaN,0.0,-7.438,0.
3552,NaN,0.0,-7.688,0.3552,NaN,0.0,-7.938), Dual{ForwardDiff.Tag{Optimizati
onProblems.ADNLPProblems.var"#f#1329"{Float16}, Float16}}(0.3552,NaN,0.0,-8
.375,0.3552,NaN,0.0,-8.875,0.3552,NaN,0.0,-9.375,0.3552), Dual{ForwardDiff.
Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float16}, Float16}}(NaN
,0.0,-9.875,0.3552,NaN,0.0,-10.375,0.3552,NaN,0.0,-10.875,0.3552,NaN), Dual
{ForwardDiff.Tag{OptimizationProblems.ADNLPProblems.var"#f#1329"{Float16}, 
Float16}}(0.0,-11.375,0.3552,NaN,0.0,-13.5,-4.42e3,NaN,0.0,-12.0,-0.02345,N
aN,0.0)])), ADNLPModels.ForwardDiffADHvprod(), ADNLPModels.ForwardDiffADJpr
od(), ADNLPModels.ForwardDiffADJtprod(), ADNLPModels.ForwardDiffADJacobian(
0), ADNLPModels.ForwardDiffADHessian(78), ADNLPModels.ForwardDiffADGHjvprod
())
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
Float16(126.0)
```


