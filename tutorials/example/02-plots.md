@def title = "Example 02 - Plots"
@def showall = true
@def tags = ["example", "plots"]

\preamble{Abel Soares Siqueira}

```julia
# using Plots

x = range(-2, 2, length=20)
y = sin.(x) * 0.2 + randn(20) * 0.1
# plot(
#   x,
#   y,
#   m = (3, :circle),
# )
```

```
20-element Vector{Float64}:
 -0.2108472304439175
 -0.2099805651585403
 -0.2950803084415303
 -0.3487183073284822
 -0.1173641234517009
 -0.1487681834774441
 -0.027575253624746235
  0.15626771503577122
  0.05680731458540491
 -0.09218203074874078
  0.1594151257125904
  0.12518362088234766
  0.04327934723788282
  0.1483719483050447
  0.19027289267869585
  0.12042269015601079
  0.08004795423812348
  0.2517458091663901
 -0.0360572166551035
  0.2143018641112039
```





```
using JSOTutorials
JSSOTutorials.tutorial_footer(WEAVE_ARGS[:folder],WEAVE_ARGS[:file])
```
