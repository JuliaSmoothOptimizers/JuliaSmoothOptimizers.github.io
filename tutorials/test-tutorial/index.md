@def title = "Test tutorial"
@def showall = true
@def tags = ["testing", "youtube", "jso"]

\preamble{Abel S. Siqueira}


![Distributions 0.25.80](https://img.shields.io/badge/Distributions-0.25.80-000?style=flat-square&labelColor=fff)



Hi, this is a test tutorial.

```julia
using Distributions

d = Normal()
rand(d, 10)
```

```plaintext
10-element Vector{Float64}:
 -0.5175670991435029
 -0.08642476523719532
 -0.08941078776581085
  2.3892294097985936
 -0.6655734353793633
 -0.0034254277328542833
 -0.9172850000300038
  0.36317683801212647
  0.5766259655860152
  0.06219957394415615
```

