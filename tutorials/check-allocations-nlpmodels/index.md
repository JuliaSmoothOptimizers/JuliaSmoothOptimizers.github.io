@def title = "Test allocations of NLPModels"
@def showall = true
@def tags = ["models", "manual", "tests"]

\preamble{Tangi Migot}


[![NLPModels 0.19.2](https://img.shields.io/badge/NLPModels-0.19.2-8b0000?style=flat-square&labelColor=cb3c33)](https://juliasmoothoptimizers.github.io/NLPModels.jl/stable/)
[![NLPModelsTest 0.8.3](https://img.shields.io/badge/NLPModelsTest-0.8.3-8b0000?style=flat-square&labelColor=cb3c33)](https://juliasmoothoptimizers.github.io/NLPModelsTest.jl/stable/)



# Test allocations of NLPModels

 [NLPModels.jl](https://github.com/JuliaSmoothOptimizers/NLPModels.jl) provides features to test allocations of any model following the NLPModel API.

Given a model `nlp` whose type is a subtype of `AbstractNLPModel` or `AbstractNLSModel`, the function [`test_allocs_nlpmodels`](@ref) returns a `Dict` containing the allocations of each of the following:
- `obj(nlp, x)` (or `obj(nlp, x, Fx)` for `AbstractNLSModel`);
- `grad!(nlp, x, gx)` (or `grad!(nlp, x, gx, Fx)` for `AbstractNLSModel`);
- `hess_structure!(nlp, rows, cols)`;
- `hess_coord!(nlp, x, vals)`;
- `hprod!(nlp, x, v, Hv)`;
- `mul!(Hv, H, v)` for a `H` a LinearOperator, see [LinearOperators.jl](https://github.com/JuliaSmoothOptimizers/LinearOperators.jl), obtained by `hess_op!(nlp, x, Hv)`.

If the problem has constraints, we also check:
- `cons!(nlp, x, c)`;
- `jac_structure!(nlp, rows, cols)`;
- `jac_coord!(nlp, x, vals)`;
- `jprod!(nlp, x, v, Jv)`;
- `jtprod!(nlp, x, v, Jtv)`;
- `mul!(Jv, J, v)` for a `J` a LinearOperator obtained by `jac_op!(nlp, x, Jv, Jtv)`;
- `hess_coord!(nlp, x, y, vals)`;
- `hprod!(nlp, x, y, v, Hv)`;
- `mul!(Hv, H, v)` for a `H` a LinearOperator obtained by `hess_op!(nlp, x, y, Hv)`.

It is also possible to test the functions for the linear and nonlinear constraints by setting the keyword `linear_api = true` in the call to [`test_allocs_nlpmodels`](@ref).

For nonlinear least-squares, i.e., `AbstractNLSModel`, we can also test allocations of the functions related to the residual evaluation with the function [`test_allocs_nlsmodels`](@ref):
- `residual!(nlp, x, Fx)`
- `jac_structure_residual!(nlp, rows, cols)`
- `jac_coord_residual!(nlp, x, vals)`
- `jprod_residual!(nlp, x, v, Jv)`
- `jtprod_residual!(nlp, x, w, Jtv)`
- `mul!(Jv, J, v)` for a `J` a LinearOperator obtained by `jac_op_residual!(nlp, x, Jv, Jtv)`;
- `hess_structure_residual!(nlp, rows, cols)`
- `hess_coord_residual!(nlp, x, v, vals)`
- `hprod_residual!(nlp, x, i, v, Hv)`
- `mul!(Hv, H, v)` for a `H` a LinearOperator obtained by `hess_op_residual!(nlp, x, i, Hv)`.

The function [`print_nlp_allocations`](@ref) allows a better rending of the results.

## Examples

### Examples with an NLPModel

```julia
using NLPModelsTest
list_of_problems = NLPModelsTest.nlp_problems
```

```plaintext
10-element Vector{String}:
 "BROWNDEN"
 "HS5"
 "HS6"
 "HS10"
 "HS11"
 "HS13"
 "HS14"
 "LINCON"
 "LINSV"
 "MGH01Feas"
```



```julia
nlp = eval(Symbol(list_of_problems[1]))()
```

```plaintext
NLPModelsTest.BROWNDEN{Float64, Vector{Float64}}
  Problem name: BROWNDEN_manual
                  All variables: ████████████████████ 4                     All constraints: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                           free: ████████████████████ 4                                free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                          lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                          upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                        low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                             low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                          fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                         infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                              infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: (  0.00% sparsity)   10                             linear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                                                  nonlinear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                                        nnzj: (------% sparsity)         

  Counters:
                            obj: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                grad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                cons: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                       cons_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                            cons_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                jcon: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                          jgrad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                 jac: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                             jac_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                        jac_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               jprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                           jprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                      jprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                              jtprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                          jtprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                     jtprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                hess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               hprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                          jhess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                              jhprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0
```



```julia
print_nlp_allocations(nlp)
```

```plaintext
Problem name: BROWNDEN_manual
                            obj: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                    hess_coord!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                          grad!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                hess_structure!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                         hprod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                  hess_op_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   

Dict{Symbol, Float64} with 6 entries:
  :obj             => 0.0
  :hess_coord!     => 0.0
  :grad!           => 0.0
  :hess_structure! => 0.0
  :hprod!          => 0.0
  :hess_op_prod!   => 0.0
```



```julia
nlp = eval(Symbol(list_of_problems[7]))()
```

```plaintext
NLPModelsTest.HS14{Float64, Vector{Float64}}
  Problem name: HS14_manual
                  All variables: ████████████████████ 2                     All constraints: ████████████████████ 2     
                           free: ████████████████████ 2                                free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                          lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               lower: ██████████⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 1     
                          upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                        low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                             low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                          fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               fixed: ██████████⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 1     
                         infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                              infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: ( 33.33% sparsity)   2                              linear: ██████████⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 1     
                                                                                  nonlinear: ██████████⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 1     
                                                                        nnzj: (  0.00% sparsity)   4     

  Counters:
                            obj: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                grad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                cons: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                       cons_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                            cons_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                jcon: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                          jgrad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                 jac: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                             jac_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                        jac_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               jprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                           jprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                      jprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                              jtprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                          jtprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                     jtprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                hess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               hprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                          jhess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                              jhprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0
```



```julia
print_nlp_allocations(nlp, linear_api = true)
```

```plaintext
Problem name: HS14_manual
                     jprod_nln!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
         jac_op_transpose_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                    hess_coord!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                      cons_lin!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
     jac_nln_op_transpose_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                 jac_structure!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
             jac_lin_structure!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                      cons_nln!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                    jtprod_nln!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
             jac_nln_structure!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                    jtprod_lin!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                   jac_op_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
     jac_lin_op_transpose_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
              hess_lag_op_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
               jac_lin_op_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                         hprod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                         jprod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
               jac_nln_op_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                          cons!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                          grad!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                  hess_op_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                     hprod_lag!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                        jtprod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                            obj: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                     jprod_lin!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                hess_lag_coord!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                     jac_coord!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                 jac_nln_coord!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                hess_structure!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                 jac_lin_coord!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   

Dict{Symbol, Float64} with 30 entries:
  :jprod_nln!                 => 0.0
  :jac_op_transpose_prod!     => 0.0
  :hess_coord!                => 0.0
  :cons_lin!                  => 0.0
  :jac_nln_op_transpose_prod! => 0.0
  :jac_structure!             => 0.0
  :jac_lin_structure!         => 0.0
  :cons_nln!                  => 0.0
  :jtprod_nln!                => 0.0
  :jac_nln_structure!         => 0.0
  :jtprod_lin!                => 0.0
  :jac_op_prod!               => 0.0
  :jac_lin_op_transpose_prod! => 0.0
  :hess_lag_op_prod!          => 0.0
  :jac_lin_op_prod!           => 0.0
  :hprod!                     => 0.0
  :jprod!                     => 0.0
  :jac_nln_op_prod!           => 0.0
  :cons!                      => 0.0
  ⋮                           => ⋮
```





### Examples with an NLSModels

```julia
list_of_problems = NLPModelsTest.nls_problems
```

```plaintext
4-element Vector{String}:
 "LLS"
 "MGH01"
 "NLSHS20"
 "NLSLC"
```



```julia
nls = eval(Symbol(list_of_problems[4]))()
```

```plaintext
NLPModelsTest.NLSLC{Float64, Vector{Float64}}
  Problem name: NLSLINCON
                  All variables: ████████████████████ 15                    All constraints: ████████████████████ 11                      All residuals: ████████████████████ 15    
                           free: ████████████████████ 15                               free: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                              linear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                          lower: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               lower: ██████⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 3                           nonlinear: ████████████████████ 15    
                          upper: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               upper: ████████⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 4                 nnzj: ( 93.33% sparsity)   15    
                        low/upp: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                             low/upp: ██⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 1                 nnzh: ( 87.50% sparsity)   15    
                          fixed: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               fixed: ██████⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 3     
                         infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                              infeas: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
            nnzh: ( 87.50% sparsity)   15                             linear: ████████████████████ 11    
                                                                                  nonlinear: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                                                                        nnzj: ( 89.70% sparsity)   17    

  Counters:
                            obj: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                grad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                cons: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                       cons_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                            cons_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                jcon: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                          jgrad: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                 jac: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                             jac_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                        jac_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               jprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                           jprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                      jprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                              jtprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                          jtprod_lin: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                     jtprod_nln: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                                hess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                               hprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                          jhess: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                              jhprod: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                            residual: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                   jac_residual: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                      jprod_residual: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                     jtprod_residual: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0     
                  hess_residual: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                      jhess_residual: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0                      hprod_residual: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0
```



```julia
print_nlp_allocations(nls, linear_api = true)
```

```plaintext
Problem name: NLSLINCON
         hess_op_residual_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
         jac_op_transpose_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                    hess_coord!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                      cons_lin!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
             jac_lin_structure!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                 jac_structure!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
jac_op_residual_transpose_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
       hess_structure_residual!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
           hess_coord_residual!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                    jtprod_lin!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                   jac_op_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
     jac_lin_op_transpose_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
              hess_lag_op_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
            jac_coord_residual!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
               jac_lin_op_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                         hprod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
               jtprod_residual!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                         jprod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                          cons!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
        jac_structure_residual!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                jprod_residual!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                          grad!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
          jac_op_residual_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                  hess_op_prod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                     hprod_lag!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                        jtprod!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                            obj: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                     jprod_lin!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                hess_lag_coord!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                hprod_residual!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                     jac_coord!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                hess_structure!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                 jac_lin_coord!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   
                      residual!: ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ 0.0   

Dict{Symbol, Float64} with 34 entries:
  :hess_op_residual_prod!          => 0.0
  :jac_op_transpose_prod!          => 0.0
  :hess_coord!                     => 0.0
  :cons_lin!                       => 0.0
  :jac_lin_structure!              => 0.0
  :jac_structure!                  => 0.0
  :jac_op_residual_transpose_prod! => 0.0
  :hess_structure_residual!        => 0.0
  :hess_coord_residual!            => 0.0
  :jtprod_lin!                     => 0.0
  :jac_op_prod!                    => 0.0
  :jac_lin_op_transpose_prod!      => 0.0
  :hess_lag_op_prod!               => 0.0
  :jac_coord_residual!             => 0.0
  :jac_lin_op_prod!                => 0.0
  :hprod!                          => 0.0
  :jtprod_residual!                => 0.0
  :jprod!                          => 0.0
  :cons!                           => 0.0
  ⋮                                => ⋮
```





### Examples with a testing environment

The function [`test_zero_allocations`](@ref) combines [`test_allocs_nlpmodels`](@ref) and [`test_allocs_nlsmodels`](@ref) in a testing environment.

```julia
list_of_nlps = map(x -> eval(Symbol(x))(), NLPModelsTest.nlp_problems) # load a list of nlpmodels
map(
    nlp -> test_zero_allocations(nlp, linear_api = true),
    list_of_nlps,
)
```

```plaintext
Test Summary:                                          | Pass  Total  Time
Test 0-allocations of NLPModel API for BROWNDEN_manual |    6      6  0.1s
Test Summary:                                     | Pass  Total  Time
Test 0-allocations of NLPModel API for HS5_manual |    6      6  0.0s
Test Summary:                                     | Pass  Total  Time
Test 0-allocations of NLPModel API for HS6_manual |   23     23  0.0s
Test Summary:                                      | Pass  Total  Time
Test 0-allocations of NLPModel API for HS10_manual |   23     23  0.0s
Test Summary:                                      | Pass  Total  Time
Test 0-allocations of NLPModel API for HS11_manual |   23     23  0.0s
Test Summary:                                      | Pass  Total  Time
Test 0-allocations of NLPModel API for HS13_manual |   23     23  0.0s
Test Summary:                                      | Pass  Total  Time
Test 0-allocations of NLPModel API for HS14_manual |   30     30  0.0s
Test Summary:                                        | Pass  Total  Time
Test 0-allocations of NLPModel API for LINCON_manual |   23     23  0.0s
Test Summary:                                       | Pass  Total  Time
Test 0-allocations of NLPModel API for LINSV_manual |   23     23  0.0s
Test Summary:                                           | Pass  Total  Time
Test 0-allocations of NLPModel API for MGH01Feas_manual |   30     30  0.0s
10-element Vector{Test.DefaultTestSet}:
 Test.DefaultTestSet("Test 0-allocations of NLPModel API for BROWNDEN_manual", Any[], 6, false, false, true, 1.676395981542906e9, 1.676395981602579e9)
 Test.DefaultTestSet("Test 0-allocations of NLPModel API for HS5_manual", Any[], 6, false, false, true, 1.67639598251377e9, 1.676395982513804e9)
 Test.DefaultTestSet("Test 0-allocations of NLPModel API for HS6_manual", Any[], 23, false, false, true, 1.676395983644847e9, 1.676395983644892e9)
 Test.DefaultTestSet("Test 0-allocations of NLPModel API for HS10_manual", Any[], 23, false, false, true, 1.676395984786401e9, 1.676395984786434e9)
 Test.DefaultTestSet("Test 0-allocations of NLPModel API for HS11_manual", Any[], 23, false, false, true, 1.676395985950405e9, 1.676395985950438e9)
 Test.DefaultTestSet("Test 0-allocations of NLPModel API for HS13_manual", Any[], 23, false, false, true, 1.676395987078775e9, 1.676395987078811e9)
 Test.DefaultTestSet("Test 0-allocations of NLPModel API for HS14_manual", Any[], 30, false, false, true, 1.676395987086485e9, 1.676395987086518e9)
 Test.DefaultTestSet("Test 0-allocations of NLPModel API for LINCON_manual", Any[], 23, false, false, true, 1.676395988421904e9, 1.676395988421939e9)
 Test.DefaultTestSet("Test 0-allocations of NLPModel API for LINSV_manual", Any[], 23, false, false, true, 1.676395989532357e9, 1.676395989532391e9)
 Test.DefaultTestSet("Test 0-allocations of NLPModel API for MGH01Feas_manual", Any[], 30, false, false, true, 1.676395990833075e9, 1.676395990833123e9)
```





Note that all the problems manually implemented in this package are allocations free using Julia ≥ 1.7.
