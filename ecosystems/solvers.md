@def title = "Solvers Ecosystem"

# Solvers Ecosystem

The solver ecosystem in JSO is in constant development.
We are looking into unifying the solver structure to make solvers, subsolvers, and tools plug-and-play.

Within JSO, our solver development has focused on three types of packages:
- New methods, usually accompanied by research papers;
- our implementation of (well- or no-so-well-)known methods;
- wrappers around noteworthy solvers implemented in other languages.

## Solver list

Below is the list of solvers and the type of problems that they are designed to solve.

| Solver     | Package       | Description                                                         | Types of problem          |
| ---------- | ------------- | ------------------------------------------------------------------- | ------------------------- |
| `cannoles` | CaNNOLeS.jl   | Regularization method for nonlinear least squares                   | Equality-constrained NLS  |
| `dci`      | DCISolver.jl  | Trust-cylinder similar to two-step SQP                              | Equality-constrained NLP  |
| `lbfgs`    | JSOSolvers.jl | Factorization-free linesearch limited-memory inverse BFGS           | Unconstrained NLP         |
| `percival` | Percival.jl   | Factorization-free augmented Lagrangian                             | Generally-constrained NLP |
| `ripqp`    | RipQP.jl      | Regularized Interior-Point Quadratic Programming                    | Convex QP (incl. LP)      |
| `tron`     | JSOSolvers.jl | Factorization-free trust-region second-order or quasi-Newton method | Bound-constrained NLP     |
| `tronls`   | JSOSolvers.jl | Least-squares versions of `tron`                                    | Unconstrained NLS         |
| `trunk`    | JSOSolvers.jl | Factorization-free trust-region second-order or quasi-Newton method | Unconstrained NLP         |
| `trunkls`  | JSOSolvers.jl | Least-squares version of `trunk`                                    | Unconstrained NLS         |

## Types of problems

Our optimization problems can be defined as

$$\text{minimize} \quad f(x) \quad \text{subject to} \quad x \in \Omega.$$

Our constraint types and their meanings are:
- Unconstrained: $\Omega = \R^n$.
- Bound constrained: $\Omega = \{x \in \R^n |\ \ell \leq x \leq u\}$.
- Equality constrained: $\Omega = \{x \in \R^n |\ c(x) = 0\}$.
- Generally constrained: $\Omega = \{x \in \R^n |\ c_L \leq c(x) \leq c_U \}$, where $c_{L_i} = c_{U_i}$ is a valid possibility, as are $c_{L_i} = -\infty$ and $c_{U_i} = \infty$, but not at the same time.

In addition to differences in the constraints, we also have different objective types:
- **NLP**: General objective.
  The objective $f(x)$ of these problems has no special structure to exploit. Access to its derivatives occurs through the default NLPModels.jl API.
- **NLS**: Nonlinear Least-Squares problems.
  These problems are defined by $f(x) = \tfrac{1}{2}\Vert F(x)\Vert^2$, with $F$ and its derivatives available through the API for NLSModels, part of NLPModels.jl
- **QP**: Quadratic Programming.
  These problems are defined by $f(x) = \tfrac{1}{2}x^T Q x + g^T x + c$, with the API defined by QuadraticModels.jl.