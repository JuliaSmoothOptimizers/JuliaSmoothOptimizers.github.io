@def title = "Solvers Ecosystem"

# Solvers Ecosystem

The solver ecosystem in JSO is in constant development.
We are looking into unifying the solver structure to plug-and-play usage of our solvers, subsolvers, and tools.

Within JSO, our solver development has focused on three types of packages:
- New methods, usually acompanied by research papers
- Our versions of well-known methods;
- Wrappers around noteworthy solvers.

## Solver list

Below you can see our list. We explain the types of problem below.

| Solver     | Package       | Description                                                  | Types of problem         |
| ---------- | ------------- | ------------------------------------------------------------ | ------------------------ |
| `cannoles` | CaNNOLeS.jl   | Regularization method for nonlinear least squares.           | Equality-constrained NLS |
| `dci`      | DCISolver.jl  | Trust-cylinder similar to two-step SQP.                      | Equality-constrained     |
| `lbfgs`    | JSOSolvers.jl | Line search Limited memory inverse BFGS. Factorization-free. | Unconstrained            |
| `percival` | Percival.jl   | Augmented Lagrangian. Factorization-free.                    | Any constrained          |
| `tron`     | JSOSolvers.jl | Trust-region second-order method. Factorization-free.        | Bound-constrained        |
| `tronls`   | JSOSolvers.jl | Least-squares versions of `tron`.                            | Unconstrained NLS        |
| `trunk`    | JSOSolvers.jl | Trust-region second-order method. Factorization-free.        | Unconstrained            |
| `trunkls`  | JSOSolvers.jl | Least-squares version of `trunk`.                            | Unconstrained NLS        |

## Types of problem

Our optimization problems can be defined as

$$\text{minimize} \quad f(x) \quad \text{subject to} \quad x \in \Omega.$$

Our constraint types and their meanings are:
- Unconstrained: $\Omega = \R^n$.
- Bound-constrained: $\Omega = \{x \in \R^n |\ \ell \leq x \leq u\}$.
- Equality-constraints: $\Omega = \{x \in \R^n |\ c(x) = 0\}$.
- Any constrained: $\Omega = \{x \in \R^n |\ c_L \leq c(x) \leq c_U \}$, where $c_{L_i} = c_{U_i}$ is a valid possibility, as are $c_{L_i} = -\infty$ and $c_{U_i} = \infty$, but not at the same time.

In addition to constraints differences, we also have NLS problems, i.e., Nonlinear Least Squares problems.
These problems are defined by $f(x) = \tfrac{1}{2}\Vert F(x)\Vert^2$, with $F$ and its derivatives available through the API for NLSModels.