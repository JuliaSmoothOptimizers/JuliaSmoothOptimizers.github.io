@def title = "New package: PDENLPModels.jl"
@def rss_description = "We are very happy to announce the publication in the Journal of Open Source Software of the paper PDENLPModels.jl: A NLPModel API for optimization problems with PDE-constraints."

# New package: PDENLPModels.jl

We are very happy to announce the publication in the Journal of Open Source Software of the paper **PDENLPModels.jl: A NLPModel API for optimization problems with PDE-constraints**. It is accessible in open access [here](https://joss.theoj.org/papers/10.21105/joss.04736).

[PDENLPModels.jl](https://github.com/JuliaSmoothOptimizers/PDENLPModels.jl) is a Julia package that specializes the [NLPModel API](https://github.com/JuliaSmoothOptimizers/NLPModels.jl) for modeling and discretizing optimization problems with mixed algebraic and PDE in the constraints.

We consider optimization problems of the form: find functions $y, u$ and $κ \in \mathbb{R}^n$ satisfying
```math
min      ∫_Ω​ f(κ,y,u) dΩ​
s.t.     y solution of a PDE(κ,u)=0
         lcon <= c(κ,y,u) <= ucon
         lvar <= (κ,y,u)  <= uvar
```

The main challenges in modeling such a problem are to be able to discretize the domain and generate corresponding discretizations of the objective and constraints, and their evaluate derivatives with respect to all variables.
We use [Gridap.jl](https://github.com/gridap/Gridap.jl) to define the domain, meshes, function spaces, and finite-element families to approximate unknowns, and to model functionals and sets of PDEs in a weak form. 
PDENLPModels extends [Gridap.jl](https://github.com/gridap/Gridap.jl)'s differentiation facilities to also obtain derivatives useful for optimization, i.e., first and second derivatives of the objective and constraint functions with respect to controls and finite-dimensional variables.

After discretization of the domain $\Omega$, the integral, and the derivatives, the resulting problem is a nonlinear optimization problem.
PDENLPModels exports the `GridapPDENLPModel` type, an instance of an `AbstractNLPModel`, as defined in [NLPModels.jl](https://github.com/JuliaSmoothOptimizers/NLPModels.jl), which provides access to objective and constraint function values, to their first and second derivatives, and to any information that a solver might request from a model. 
The role of [NLPModels.jl](https://github.com/JuliaSmoothOptimizers/NLPModels.jl) is to define an API that users and solvers can rely on. It is the role of other packages to implement facilities that create models compliant with the NLPModels API. We refer to [juliasmoothoptimizers.github.io](https://juliasmoothoptimizers.github.io) for tutorials on the NLPModel API.

As such, PDENLPModels offers an interface between generic PDE-constrained optimization problems and cutting-edge optimization solvers such as Artelys Knitro via [NLPModelsKnitro.jl](https://github.com/JuliaSmoothOptimizers/NLPModelsKnitro.jl), Ipopt via [NLPModelsIpopt.jl](https://github.com/JuliaSmoothOptimizers/NLPModelsIpopt.jl) , [DCISolver.jl](https://github.com/JuliaSmoothOptimizers/DCISolver.jl), [Percival.jl](https://github.com/JuliaSmoothOptimizers/Percival.jl), and any solver accepting an `AbstractNLPModel` as input, see [JuliaSmoothOptimizers](https://juliasmoothoptimizers.github.io).

## Example

The following example shows how to solve a Poisson control problem with Dirichlet boundary conditions using [`DCISolver.jl`](https://github.com/JuliaSmoothOptimizers/DCISolver.jl):
\begin{equation*}
  \begin{array}{lll}
    \underset{y, u}{\text{minimize}} \int_{(-1,1)^2} \frac{1}{2}\|y_d - y\|^2 +\frac{\alpha}{2}\|u\|^2 d\Omega \quad \mbox{subject to} & \Delta y - u - h = 0, & \mbox{on } \Omega.\\
    & y = 0, & \mbox{on } \partial\Omega,
  \end{array}
\end{equation*}

$$
  \begin{array}{lll}
    \underset{y, u}{\text{minimize}} \int_{(-1,1)^2} \frac{1}{2}\|y_d - y\|^2 +\frac{\alpha}{2}\|u\|^2 d\Omega \quad \text{subject to} & \Delta y - u - h = 0, & \text{on } \Omega.\\
    & y = 0, & \text{on } \partial\Omega,
  \end{array}
$$
find functions $y \in H^1_0$ and $u \in H^1$ satisfying
```math
min   0.5 ∫_Ω​ |y(x) - yd(x)|^2dx + 0.5 * α * ∫_Ω​ |u|^2
s.t.          -Δy = u + h,   for    x ∈  Ω
               y  = 0,       for    x ∈ ∂Ω
where yd(x) = -x[1]^2, h(x) = 1 and α = 1e-2.
```
for some given functions $y_d:(-1,1)^2 \rightarrow \mathbb{R}$ and $h:(-1,1)^2 \rightarrow \mathbb{R}$, and $\alpha > 0$.

```julia
using DCISolver, Gridap, PDENLPModels

# Cartesian discretization of Ω=(-1,1)² in 100² squares.
Ω = (-1, 1, -1, 1)
model = CartesianDiscreteModel(Ω, (100, 100))
fe_y = ReferenceFE(lagrangian, Float64, 2) # Finite-elements for the state
Xpde = TestFESpace(model, fe_y; dirichlet_tags = "boundary")
Ypde = TrialFESpace(Xpde, x -> 0.0) # y is 0 over ∂Ω
fe_u = ReferenceFE(lagrangian, Float64, 1) # Finite-elements for the control
Xcon = TestFESpace(model, fe_u)
Ycon = TrialFESpace(Xcon)
dΩ = Measure(Triangulation(model), 1) # Gridap's integration machinery

# Define the objective function f
yd(x) = -x[1]^2
f(y, u) = ∫(0.5 * (yd - y) * (yd - y) + 0.5 * 1e-2 * u * u) * dΩ

# Define the constraint operator in weak form
h(x) = -sin(7π / 8 * x[1]) * sin(7π / 8 * x[2])
c(y, u, v) = ∫(∇(v) ⊙ ∇(y) - v * u - v * h) * dΩ

# Define an initial guess for the discretized problem
x0 = zeros(num_free_dofs(Ypde) + num_free_dofs(Ycon))

# Build a GridapPDENLPModel, which implements the NLPModel API.
name = "Control elastic membrane"
nlp = GridapPDENLPModel(x0, f, dΩ, Ypde, Ycon, Xpde, Xcon, c, name = name)

dci(nlp, verbose = 1) # solve the problem with DCI
```

## References

> Migot, T., Orban D., & Siqueira A. S.
> PDENLPModels.jl: A NLPModel API for optimization problems with PDE-constraints
> Journal of Open Source Software 7(80), 4736 (2022).
> [10.21105/joss.04736](https://doi.org/10.21105/joss.04736)
