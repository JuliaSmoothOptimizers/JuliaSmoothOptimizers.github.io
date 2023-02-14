@def title = "Test tutorial"
@def showall = true
@def tags = ["testing", "youtube", "jso"]

\preamble{Abel S. Siqueira}


![Distributions 0.25.80](https://img.shields.io/badge/Distributions-0.25.80-000?style=flat-square&labelColor=999)



Hi, this is a test tutorial.

```julia
using Distributions

d = Normal()
rand(d, 10)
```

```plaintext
10-element Vector{Float64}:
 -1.4311289924864383
  0.7576739272296517
  1.3845826956400125
  0.8040235857250309
  0.1810379996065371
  0.09311488085064536
 -0.7254493239985511
 -1.5056899172537448
  0.972179314265765
 -1.1594310594121675
```

