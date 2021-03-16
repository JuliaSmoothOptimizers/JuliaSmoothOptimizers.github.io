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

Our packages in this ecosystem define a computation structure to hold all the information above of a problem and an API to access the derivatives of the given functions.