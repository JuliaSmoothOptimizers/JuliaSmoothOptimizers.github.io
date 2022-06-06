@def title = "Linear Algebra Ecosystem"

# Linear Algebra Ecosystem

Inside an optimization method, we frequently have to deal with matrices and linear operations/
There are 2 main linear problems that we need to solve:

- **Linear systems**: Find $x \in \R^n$ such that $Ax = b$, where $A \in \R^{m\times n}$ and $b \in \R^m$.
- **Least squares problems**: Find $x \in \R^n$ that minimizes $\|Ax - b\|^2$, where $A \in \R^{m\times n}$ and $b \in \R^m$.

There is a wide variety of methods to solve these problems, usually specialized with respect to additional properties of $A$ and $b$.
Inside JSO we implement a few of those methods, and provide code wrapper around some others.

Our main interest lies in large-scale problems, that are dealt with either by

- **Factorization-free methods**: $A$ itself is not available, but we have access to the result of the product of $A$ by a vector $v$. That is, we have a function $v \to Av$. Possibly we have access to $v \to A^T v$ and $v \to A^*v$ as well.
- **Sparse factorization**: $A$ is factorized into a product of matrices. The issue here being that since $A$ is sparse, the factorization algorithm has to be smart enough to not destroy the sparsity of the problem.

We'll describe in the following sections the main packages of our ecosystem divided in these two categories.

## Factorization-free methods

### LinearOperators

The first thing we did for this section of the ecosystem was define a new type for linear operators, with the package LinearOperators.
The package is used internally by our models to provide access to the Jacobian and Hessian vector products, so it is considered a main package for the organization as a whole.

### Krylov

The second main package in this part if the package Krylov, which defines almost 30 methods for linear system and linear least-squares problems.
Krylov implements a few known methods, but brand new methods were developed and published as well.

## Factorization methods

### HSL

Factorization methods have been studied for a few decades, and some packages are well-known for doing it right.
One of these packages is HSL, which defines some well-known methods such as MA57 and MA97.
Our HSL wrapper exports both of these methods, which are the main ones used in our context.

### LDLFactorizations

Two drawbacks of HSL are that it is proprietary and it can't handle element types except 32 bits and 64 bits native floating point numbers.
LDLFactorizations implements a factorization for symmetric matrices to compete with MA57 that solves both of these problems.