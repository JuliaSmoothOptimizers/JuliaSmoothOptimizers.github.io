@def title = "Test tutorial"
@def showall = true
@def tags = ["testing", "youtube", "jso"]

\preamble{Abel S. Siqueira}


![Distributions 0.25.80](https://img.shields.io/badge/Distributions-0.25.80-000?style=flat-square&labelColor=fff")



Hi, this is a test tutorial.

```julia
using Distributions

d = Normal()
rand(d, 10)
```

```plaintext
10-element Vector{Float64}:
  3.3281947520722763
  2.0563656434221245
 -1.8210849441599968
  0.1074185813955539
  1.5251275657891605
 -0.27232158287918556
 -0.879571693519545
 -1.0712291397235432
  0.24233668927693447
 -1.1633496530595322
```

