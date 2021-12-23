# This file was generated, do not modify it. # hide
#hideall
dir = "pages/tutorials/"
for fmd in readdir(dir)
  fmd == "list.md" && continue
  f = split(fmd, ".")[1]
  path = joinpath(dir, f)
  println("- [{{fill title $path}}](/$path)")
end