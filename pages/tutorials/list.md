@def title = "Tutorials"

# Tutorials

This is a curated list of tutorials.

```julia:./list-all-tutorials.jl
#hideall
dir = "pages/tutorials/"
for fmd in readdir(dir)
  fmd == "list.md" && continue
  f = split(fmd, ".")[1]
  path = joinpath(dir, f)
  println("- [{{fill title $path}}](/$path)")
end
```
\textoutput{./list-all-tutorials}

## External tutorials

This is another list of tutorials, though not curated.

- [Abel Siqueira's YouTube playlist on JSO Tutorials](https://www.youtube.com/playlist?list=PLOOY0eChA1uxmm8G2caFpdX7X9NjgpDUY), Abel Soares Siqueira, 08 April 2020
- [NLPModels.jl and CUTEst.jl: Constrained Optimization](http://abelsiqueira.github.io/blog/nlpmodelsjl-and-cutestjl-constrained-optimization/), Abel Soares Siqueira, 17 February 2017
- [NLPModels.jl, CUTEst.jl and other Nonlinear Optimization Packages on Julia](http://abelsiqueira.github.io/blog/nlpmodelsjl-cutestjl-and-other-nonlinear-optimization-packages-on-julia/), Abel Soares Siqueira, 07 February 2017