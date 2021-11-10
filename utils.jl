using Pkg, Markdown

const jso_pkgs = ["ADNLPModels", "JSOSolvers", "LinearOperators", "NLPModels", "NLPModelsIpopt", "NLPModelsJuMP", "SolverBenchmark", "SolverTools"]

function badge(name, version)
  color, lbl_color = if name in jso_pkgs
    h = div(360 * findfirst(name .== jso_pkgs), length(jso_pkgs))
    "hsl($h,100%25,30%25)", "hsl($h,30%25,30%25)"
  else
    "666", "444"
  end

  "<img class=\"badge\" src=\"https://img.shields.io/badge/$name-$version-$color?style=flat-square&labelColor=$lbl_color\">"
end

function hfun_list_versions(pkgs)
  dict = Pkg.installed()
  out = ""
  for pkg in pkgs
    if haskey(dict, pkg)
      out *= badge(pkg, dict[pkg]) * "\n"
    else
      out *= badge(pkg, "stdlib") * "\n"
    end
  end
  out
end