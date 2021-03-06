# LinearOperators.jl is a package for matrix-like operators. Linear operators are defined by how they act on a vector, which is useful in a variety of situations where you don't want to materialize the matrix.

# \toc

# ## Introduction

using LinearOperators

prod(v) = [3v[1] - v[2]; 2v[1] + 2v[2]]
A = LinearOperator(
  Float64, # element type
  2,       # number of rows
  2,       # number of columns
  false,   # symmetric?
  false,   # Hermitian?
  prod     # Function defining v → Av
)

@show A
A * ones(2)

# The operator can be symmetric and/or Hermitian, and products with its transpose and adjoint can be defined as well.

prod(v) = [3v[1] - v[2]; 2v[1] + 2v[2]]
tprod(v) = [3v[1] + 2v[2]; -v[1] + 2v[2]]

A = LinearOperator(Float64, 2, 2, false, false, prod, tprod)

transpose(A) * ones(2)

# Notice that since `A` defined above is real, then the adjoint transpose is inferred to also be `tprod`:

A' * ones(2)

# In the following example we define a complex operator using the Fast Fourier Transform and its inverse.
# Notice that the operator is orthogonal.

using FFTW, LinearAlgebra

A = LinearOperator(16, 16, false, false, fft, nothing, ifft)

v = rand(16) + im * rand(16)
norm(A * v - fft(v)), norm(A' * v - ifft(v)), norm(Matrix(A' * A) - I)

# ## Lazy Products

# One immediate advantage of LinearOperators is that it allows lazy matrix products.

n = 4000
A = rand(n, n)
B = rand(n, n)
opA = LinearOperator(A)
opB = LinearOperator(B)

@show opA * opB

# Run twice
@time A * B
@time opA * opB

v = rand(n)
@time A * (B * v)
@time (opA * opB) * v;

# ## Preallocated Operators

# It is often useful to reuse the memory used in a linear operator.
# If the operator is created from a matrix `A`, `PreallocatedLinearOperator(A)` automatically creates the underlying memory to store `A * v`, `transpose(A) * v` and `A' * v`.

m, n = 50, 30
A = rand(50, 30)
op1 = PreallocatedLinearOperator(A)
op2 = LinearOperator(A)
v = rand(n)

op1 * v
al = @allocated for i = 1:100
  op1 * v
end
println("Allocation of op1: $al")
op2 * v
al = @allocated for i = 1:100
  op2 * v
end
println("Allocation of op2: $al")

# ## Inverse Operator

# Operators may be defined to represent (approximate) inverses.

A = rand(5,5)
A = A' * A
op = opCholesky(A)  # Use, e.g., as a preconditioner
v = rand(5)

norm(A \ v - op * v) / norm(v)

# ## LBFGS Operator

# A useful operator is the Limited BFGS operator, which implements the BFGS update with limited memory used in nonlinear optimization. This update comes in both direct ($B_k$) and inverse ($H_k = B_k^{-1}$) form.
# $$
# B_{k+1} = B_k + \frac{y_k y_k^T}{y_k^T s_k} - \frac{B_k s_k s_k^T B_k^T}{s_k^T B_k s_k}
# $$
# $$
# H_{k+1} = \bigg(I - \frac{s_k y_k^T}{y_k^T s_k}\bigg)H_k\bigg(I - \frac{y_k s_k^T}{y_k^T s_k}\bigg) + \frac{s_k s_k^T}{y_k^T s_k}
# $$

B = LBFGSOperator(5, scaling=false) # B₀ = I
H = InverseLBFGSOperator(5, scaling=false) # H₀ = I

s = rand(5)
y = rand(5)
push!(B, s, y)
push!(H, s, y)

q = rand(5)
Bq = q + dot(y, q) / dot(y, s) * y - dot(s, q) / dot(s, s) * s
Hauxq = q - dot(s, q) / dot(y, s) * y
Hq = Hauxq - dot(y, Hauxq) / dot(y, s) * s + dot(s, q) / dot(y, s) * s

norm(B * q - Bq), norm(H * q - Hq), norm(B * H * q - q)

# ## Application: Heat Equation

# Consider a square plate of size $L \times L$ with no heat exchange on the boundaries.
# The Heat Equation and boundary conditions related to the temperature $u(t,x,y)$ at time $t$, position $(x,y)$ is given by
# $$
# \frac{\partial u}{\partial t} = \alpha \bigg(\frac{\partial^2 u}{\partial x^2} + \frac{\partial^2 u}{\partial y^2}\bigg),
# $$
# where $\alpha > 0$, and
# $$
# \frac{\partial u}{\partial x}(t,0,y) = \frac{\partial u}{\partial x}(t,L,y) =
# \frac{\partial u}{\partial y}(t,x,0) = \frac{\partial u}{\partial y}(t,x,L) = 0.
# $$

# Discretizing $t$ into $[0,t_1,\dots,t_N]$ with $\delta = t_{n+1} - t_n$, $x \in [0,L]$ into $[x_1,x_2,\dots,x_m]$ with $h = x_{i+1} - x_i$ and $y$ accordingly, with $h = y_{j+1} - y_j$, we define $u^n_{i,j}$ as the approximation to $u(t_n,x_i,y_j)$.
# The derivatives can be approximated by finite differences:
#=
$$
\begin{aligned}
  \frac{\partial u}{\partial t}(t_n,x_i,y_j) & \approx \frac{u^{n+1}_{i,j} - u^n_{i,j}}{\delta}
      \qquad \text{(Forward scheme in time)}; \\
  \frac{\partial u}{\partial x}(t_n,x_i,y_j) & \approx \frac{u^n_{i+1,j} - u^n_{i-1,j}}{2h}
      \qquad \text{(Central 1st order scheme)}; \\
  \frac{\partial^2 u}{\partial x^2}(t_n,x_i,y_j) & \approx \frac{u^n_{i+1,j} - 2u^n_{i,j} + u^n_{i-1,j}}{h^2}
      \qquad \text{(Central 2nd order scheme)}; \\
  \frac{\partial u}{\partial y}(t_n,x_i,y_j) & \approx \frac{u^n_{i,j+1} - u^n_{i,j-1}}{2h}
      \qquad \text{(Central 1st order scheme)}; \\
  \frac{\partial^2 u}{\partial y^2}(t_n,x_i,y_j) & \approx \frac{u^n_{i,j+1} - 2u^n_{i,j} + u^n_{i,j-1}}{h^2}
      \qquad \text{(Central 2nd order scheme)}.
\end{aligned}
$$

Substituting into the PDE, we obtain
$$
\frac{u^{n+1}_{i,j} - u^n_{i,j}}{\delta} = \frac{\alpha}{h^2}(-4u^n_{i,j} + u^n_{i-1,j} + u^n_{i+1,j} + u^n_{i,j-1} + u^n_{i,j+1}).
$$
This can be written as
$$
u^{n+1}_{i,j} = (1 - 4\gamma)u^n_{i,j} + \gamma\Big(u^n_{i-1,j} + u^n_{i+1,j} + u^n_{i,j-1} + u^n_{i,j+1}\Big),
$$
where $\gamma = \dfrac{\alpha\delta}{h^2}$.

To handle the boundary conditions, we need to introduce additional unknowns $u_{0,j}$, $u_{m+1,j}$, $u_{i,0}$ and $u_{i,m+1}$ for values $x = -h$, $x = L + h$, $y = -h$ and $y = L + h$, respectively. Although these values are outside the domain of interest, they help define the values inside the domain by being removed through the discretization of the boundary contitions
$$
\frac{\partial u}{\partial x}(t_n,x_1,y_j) = \frac{\partial u}{\partial x}(t_n,x_m,y_j) = \frac{\partial u}{\partial y}(t_n,x_i,y_1) = \frac{\partial u}{\partial y}(t_n,x_i,y_m) = 0.
$$
This leads to
$$
u^n_{2,j} = u^n_{0,j}, \quad
u^n_{m+1,j} = u^n_{m-1,j}, \quad
u^n_{i,2} = u^n_{i,0}, \quad
u^n_{i,m+1} = u^n_{i,m-1}.
$$

Note that in the PDE discretization, if $u^n_{0,j}$, $u^n_{m+1,j}$, $u^n_{i,0}$ or $u^n_{i,m+1}$ appear, we can substitute them by one of the inner mesh points.
For instance, for $(i,j) = (1,2)$:
$$
\begin{aligned}
u^{n+1}_{1,2} & = (1 - 4\gamma)u^n_{1,2} + \gamma\Big(u^n_{0,2} + u^n_{2,2} + u^n_{1,1} + u^n_{1,3}\Big) \\
& = (1 - 4\gamma)u^n_{1,2} + \gamma\Big(2u^n_{2,2} + u^n_{1,1} + u^n_{1,3}\Big).
\end{aligned}
$$
Another example, for $(i,j) = (1,1)$:
$$
\begin{aligned}
u^{n+1}_{1,1} & = (1 - 4\gamma)u^n_{1,1} + \gamma\Big(u^n_{0,1} + u^n_{2,1} + u^n_{1,0} + u^n_{1,2}\Big) \\
& = (1 - 4\gamma)u^n_{1,1} + \gamma\Big(2u^n_{2,1} + 2u^n_{1,2}\Big).
\end{aligned}
$$

Now we define $U^n = (u_{1,1}^n, u_{1,2}^n, \dots, u_{1,m}^n, u_{2,1}^n, \dots, u_{m,m}^n)^T$, for $n = 0,\dots,N$.
This way we can define the following recurrence relation:
$$ U^{n+1} = AU^n, $$
for some matrix $A$.
  This matrix has a very special structure. With $m = 3$, which only has one interior  mesh point, it becomes the following:
  $$
  \begin{bmatrix}
  1 - 4\gamma & 2\gamma & 0 & 2\gamma & 0 & 0 & 0 & 0 & 0 \\
  \gamma & 1 - 4\gamma & \gamma & 0 & 2\gamma & 0 & 0 & 0 & 0 \\
  0 & 2\gamma & 1 - 4\gamma & 0 & 0 & 2\gamma & 0 & 0 & 0 \\
  \gamma & 0 & 0 & 1 - 4\gamma & 2\gamma & 0 & \gamma & 0 & 0 \\
  0 & \gamma & 0 & \gamma & 1 - 4\gamma & \gamma & 0 & \gamma & 0 \\
  0 & 0 & \gamma & 0 & 2\gamma & 1 - 4\gamma & 0 & 0 & \gamma \\
  0 & 0 & 0 & 2\gamma & 0 & 0 & 1 - 4\gamma & 2\gamma & 0 \\
  0 & 0 & 0 & 0 & 2\gamma & 0 & \gamma & 1 - 4\gamma & \gamma \\
  0 & 0 & 0 & 0 & 0 & 2\gamma & 0 & 2\gamma & 1 - 4\gamma
  \end{bmatrix}.
  $$
  For $m > 3$, the above matrix can be written
  $$
  A = \begin{bmatrix}
  T & 2D \\
  D & T & D \\
  & D & T & D \\
  & & \ddots & \ddots & \ddots \\
  & & & D & T & D \\
  & & & & 2D & T
  \end{bmatrix},
  $$
  where $T$ is a tridiagonal matrix and $D = \gamma I$.

  #### Implementing

  Instead of creating the full matrix $A$, we create $A$ as an operator to save memory.

=#

function HeatEquationOp(L, m, δ, α)
  h = L / (m - 1)
  γ = α * δ / h^2
  κ = 1 - 4γ

  Tprod(v) = [κ * v[1] + 2γ * v[2];
             [γ * v[i-1] + κ * v[i] + γ * v[i+1] for i = 2:m-1];
              κ * v[m] + 2γ * v[m-1]]

  T = LinearOperator(Float64, m, m, false, false, Tprod)
  D = opEye(m) * γ

  function prod(v)
    Hv = zeros(m^2)
    Hv[1:m] .= [T  2D] * v[1:2m]
    for i = 2:m-1
      Hv[(i-1)*m+1:i*m] .= [D T D] * v[(i-2)*m+1:(i+1)*m]
    end
    Hv[end-m+1:end] .= [2D T] * v[end-2m+1:end]
    return Hv
  end

  return LinearOperator(Float64, m^2, m^2, false, false, prod)
end

# Here is an example of this operator.

A = HeatEquationOp(1.0, 3, 0.1, 0.1)
Matrix(A)

# This example shows the sparsisty pattern.

using SparseArrays, Plots
gr(size=(600,600))

A = HeatEquationOp(1.0, 20, 0.1, 0.1)
spy(sparse(Matrix(A)))
png(joinpath(@OUTPUT, "spy")) # hide

# \figalt{Sparsity of A}{spy.png}
# The next function creates a `HeatEquationOp` operator and the linearized vector `U` with starting values.

function HeatEquation(u0, L, m, δ, α)
  h = L / (m - 1)
  U = zeros(m^2)
  for i = 1:m
    x = (i - 1) * h
    for j = 1:m
      y = (j - 1) * h
      U[(i - 1)*m + j] = u0(x, y)
    end
  end
  A = HeatEquationOp(L, m, δ, α)

  return U, A
end

# Now, anytime we want to make a time step, we can simply compute `A * U`.
const dark_purple = Colors.RGB(0.584, 0.345, 0.698)
const dark_red    = Colors.RGB(0.796, 0.235, 0.200)
const dark_green  = Colors.RGB(0.220, 0.596, 0.149)
const black       = Colors.RGB(0.0, 0.0, 0.0)
colors = [black, dark_green, dark_green, dark_red, dark_red, dark_purple, dark_purple]

L = 5
u0(x, y) = begin
  d = [(x,y) -> ((x - sin(2π/3*i))^2 + (y - cos(2π/3*i))^2)^2 for i = 1:3]
  xx, yy = x - L / 2, y - L / 2
  return 3*exp(-sqrt(2)*d[1](xx,yy)) + 2*exp(-d[2](xx,yy)) + exp(-4*d[3](xx,yy))
end

grid = range(0, L, length=50)
maxu = maximum([u0(xi,yi) for xi in grid, yi in grid])
p = plot(; leg=false, size=(1000,500), layout=@layout [a b])
surface!(p[1], grid, grid, u0, c=cgrad(colors), camera=(50,70))
contour!(p[2], grid, grid, u0, levels=range(0.1, maxu, length=50), c=cgrad(colors))
png(p, joinpath(@OUTPUT, "surface1")) # hide

# \figalt{Surface and contour plot}{surface1.png}

# The following two blocks are a visualization of the solution of the Heat Equation.
# The first block show images of at different time steps.

L = 5
m = 30
δ = 0.01
α = 0.5

U0, A = HeatEquation(u0, L, m, δ, α)
U = copy(U0)

plot_rows = 4
plot_cols = 4
plots = []

Δt = 10

for i = 1:plot_rows
  for j = 1:plot_cols
    global U

    local p = surface(reshape(U, m, m), leg=false, c=cgrad(colors), camera=(50,70))
    zlims!(0, maximum(U0))
    xticks!(Float64[])
    yticks!(Float64[])
    k = (i - 1) * plot_cols + j
    title!("t = $(round(k * Δt * δ, digits=3))")
    push!(plots, p)

    for t = 1:Δt
      U = A * U
    end
  end
end
plot(plots..., layout=(plot_rows, plot_cols), size=(1000, plot_rows * 250))
png(joinpath(@OUTPUT, "surface2")) # hide

# \figalt{Surfaces along the time}{surface2.png}

# The second block shows an animation.

U0, A = HeatEquation(u0, L, m, δ, α)
U = copy(U0)

Δt = 2.5

anim = Animation()
for i = 1:60
  global U

  rU = reshape(U, m, m)
  local p = plot(; leg=false, size=(1000,500), layout=@layout [a b])
  surface!(p[1], rU, c=cgrad(colors), camera=(50,70))
  contour!(p[2], rU, levels=range(0.1, maximum(U0), length=50), c=cgrad(colors))
  zlims!(0, maximum(U0))
  frame(anim)

  for t = 1:Δt
    U = A * U
  end
end
gif(anim, joinpath(@OUTPUT, "heat-equation.gif"), fps=12) #hide

# \figalt{Animation of surface along time}{heat-equation.gif}
