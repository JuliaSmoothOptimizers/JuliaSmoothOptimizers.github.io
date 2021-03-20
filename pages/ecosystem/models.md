@def title = "Models Ecosystem"

# Models Ecosystem

In the context of nonlinear optimization, the general form of the optimization problem is

\begin{aligned}
\min \quad & f(x) \\
& c_i(x) = 0, \quad i \in E, \\
& c_{L_i} \leq c_i(x) \leq c_{U_i}, \quad i \in I, \\
& \ell \leq x \leq u,
\end{aligned}

where $f:\mathbb{R}^n\rightarrow\mathbb{R}$,
$c:\mathbb{R}^n\rightarrow\mathbb{R}^m$,
$E\cup I = \{1,2,\dots,m\}$, $E\cap I = \emptyset$,
and
$c_{L_i}, c_{U_i}, \ell_j, u_j \in \mathbb{R}\cup\{\pm\infty\}$
for $i = 1,\dots,m$ and $j = 1,\dots,n$.

We define two interested parties in this context:
- Users: People that have a problem like the one above and want to write them computationally and pass them to a solver.
- Solver developers: People that are writing optimization methods and need information about the problem to provide an approximate solution.

To solve this problem we usually require $f$ and its derivatives at a given point $x.$
However, since the function $f$ is nonlinear, determining its derivatives is usually not trivial.
This led to the creation of several ways to define and obtain the function of an optimization problem.
Furthermore, during the development of an optimization method, we want to test and compare our solver on a large variety of problems.
This means that we need a collection of test problems, and these too will follow their own format.

Therefore, one of the objectives of NLPModels is to allow the creation of different model that follow the same API.
This way, everybody is happy.

We can summarise the possibilities in 4 categories:

- **Manually pass everything**: You usually do this when you're writing your optimization method to test it. It can also be the case when you special information about the derivatives that can be explored, or when you really want to squeeze that last bit of speed.
- **Modeling languages**: A modeling language will translate a _friendly_ description of the optimization method to the function and its derivatives. This has an extra cost when creating the model, usually, to compute the structure of the derivatives.
- **Automatic differentiation**: A great new way of doing things. It's easier for the user, because you can define only $f$ manually and its derivatives are computed for you. Naturally, that also has some extra cost.
- **Specialized problem collections:** Some packages provide a curated list of problem so you can test your optimization method. To write this list you can follow any of the ways above, naturally, but as a developer you want them readily available, so someone already made the decision of how they'll be available to you.

Let's describe some of the packages available.

## Basic definitions and manual problem creation

### NLPModels

NLPModels is the base of this ecosystem, it defines an API for all other models to implement.
This is done by creating a struct derived from the abstract NLPModel type, and defining how each API function behaves for that model.
This means that you can define a struct specifically for your problem and describe the functions manually.
This is how we test our API and how we keep the consistency between models, so it can be seen in action.

### NLPModelsModifiers

This package is dedicated to models that modify existing models.
We currently have four models available. Here's a rough description:
- FeasibilityFormNLS transforms a nonlinear least-squares problems by moving the residual function to the constraints. This allows a non-specialized solver to handle the objective function much better.
- FeasibilityResidual uses the constraints of a model to create a nonlinear least-squares problem. This problem is called the Feasibility violation minimization in some cases.
- LSR1Model and LBFGSModel are models that approximate the Hessian by quasi-Newton operators. They use LinearOperators, so they don't return the full matrix, only operators.
- SlackModel transforms inequalities into equalities adding slack variables to these constraints.

### NLPModelsTest

This package is only for developers, since they are used to test models.
The rationale here is that many of the tests we want to perform were copy-pasted from one source.
With this package, we can add it only for the tests and use the prepared functions instead of copying a lot of code.
Furthermore, it's easier to keep track of everything.

### ADNLPModels

This package defines methods using automatic differentiation.
Probably some of the most useful models, since you can very quickly define a problem.

### QuadraticModels

As the name implies, for quadratic models.

### LLSModels

For linear least-squares problems.

## Modeling Language models

### NLPModelsJuMP and AmplNLReader

In this section we have models wrapping two main modeling languages.
JuMP is an open source modeling language written in Julia.
AMPL is an external modeling language that is well-known for its efficiency.

## Problem collections

### CUTEst

CUTEst is the latest iteration of the _Constraint and Unconstrained Testing Environment_.
It is a package written in Fortran, and we provide a wrapper for it.

It contains around 1500 problems for general nonlinear optimization and has been in use since at least 1995, when the paper describing the first version was released.
The problem are written in a specialized format that can almost be considered a modeling language, although it is not friendly to the user.
On the other hand, the derivatives are obtained very efficiently.

### OptimizationProblems

This package provides a list of problems implemented in JuMP.

### NLSProblems

This package provides a list of nonlinear least-squares problems implemented using NLPModelsJUMP.