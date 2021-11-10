using Pkg, Markdown

function badge(name, version)
  h = Int(hash(name) % 256^3)
  r, g, b = h % 256, div(h, 256) % 256, div(h, 256^2) % 256
  color = "rgb($r,$g,$b)"
  "<img class=\"badge\" src=\"https://img.shields.io/badge/$name-v$version-$color\">"
end

function list_versions(pkgs)
  out = "~~~\n"
  dict = Pkg.installed()
  for pkg in pkgs
    out *= badge(pkg, dict[pkg]) * "\n"
  end
  out *= "~~~"
  println(out)
end