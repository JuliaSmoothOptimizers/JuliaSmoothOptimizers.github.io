@def title = "ForwardDiff example"
@def showall = true
@def tags = ["differentiation"]

\preamble{Abel Soares Siqueira}



Consider the function below:

```julia
f(x) = (x[1] - 1)^2 + 100 * (x[2] - x[1]^2)^2
```

```
f (generic function with 1 method)
```





We use ForwardDiff for the derivatives.

```julia
using ForwardDiff
∇f(x) = ForwardDiff.gradient(f, x)
H(x) = ForwardDiff.hessian(f, x)
```

```
H (generic function with 1 method)
```





Newton's method:

```
x = [-1.2; 1.0]
for k = 1:10
  println("Iter $k - x = ", x)
  x -= H(x) \ ∇f(x)
end
```
