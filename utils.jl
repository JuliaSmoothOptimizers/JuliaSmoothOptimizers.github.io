using Pkg, Markdown

function installed()
  deps = Pkg.dependencies()
  installs = Dict{String, Any}()
  for (_, dep) in deps
    dep.is_direct_dep || continue
    installs[dep.name] = dep.version
  end
  return installs
end

const jso_pkgs = ["ADNLPModels", "JSOSolvers", "LinearOperators", "ManualNLPModels", "NLPModels", "NLPModelsIpopt", "NLPModelsJuMP", "SolverBenchmark", "SolverCore", "SolverTools"]

function badge(name, version)
  color, lbl_color = if name in jso_pkgs
    h = div(360 * findfirst(name .== jso_pkgs), length(jso_pkgs))
    "hsl($h,100%25,30%25)", "hsl($h,30%25,30%25)"
  elseif version == "STDLIB"
    "666", "444"
  else
    "666", "999"
  end

  "<img class=\"badge\" src=\"https://img.shields.io/badge/$name-$version-$color?style=flat-square&labelColor=$lbl_color\">"
end

function hfun_list_versions()
  lt_file = "_literate" * locvar("fd_rpath")[6:end-2] * "jl"
  lines = readlines(lt_file)
  pkgs = String[]
  for line in lines
    if match(r"^using", line) !== nothing
      sline = split(line[7:end], ", ")
      append!(pkgs, sline)
    end
  end
  pkgs = unique(sort(pkgs))
  dict = installed()
  out = ""
  for pkg in pkgs
    if haskey(dict, pkg)
      out *= badge(pkg, dict[pkg]) * "\n"
    elseif pkg in readdir(Base.Sys.STDLIB)
      out *= badge(pkg, "STDLIB") * "\n"
    end
  end
  out
end