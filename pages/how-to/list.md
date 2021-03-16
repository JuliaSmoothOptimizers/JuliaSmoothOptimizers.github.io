@def title = "How-to guides"

# How-to guides

This is a curated list of tutorials.

```julia:./list-all-how-to.jl
#hideall
dir = "pages/how-to/"
for fmd in readdir(dir)
  fmd == "list.md" && continue
  f = split(fmd, ".")[1]
  path = joinpath(dir, f)
  println("- [{{fill title $path}}](/$path)")
end
```
\textoutput{./list-all-how-to}