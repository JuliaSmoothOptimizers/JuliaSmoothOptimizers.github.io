using GitHub, JLD, Requests

const org = "JuliaSmoothOptimizers"
const docurl = "https://$org.github.io"
const shieldurl = "https://img.shields.io"
const style = "?style=flat" # flat, flat-square or plastic

no_appveyor = ["CUTEst.jl", "HSL.jl", "LinearOperators.jl", "MUMPS.jl",
               "qr_mumps.jl"]

shield(args; label="") = "[![]($shieldurl/$args$style&label=$label)]"
shield(svc, org, pkg; label="") = shield("$svc/$org/$pkg.svg", label=label)
shield(svc, org, pkg, br; label="") = shield(svc, org, "$pkg/$br", label=label)

APV(pkg) = lowercase(replace(pkg, ".", "-"))

travis(pkg, br) = shield("travis", org, pkg, br, label="Travis_$br") * "(https://travis-ci.org/$org/$pkg)"
appveyor(pkg, br) = shield("appveyor/ci", "dpo", APV(pkg), br, label="Appveyor_$br") * "(https://ci.appveyor.com/project/dpo/$(APV(pkg))/branch/$br)"
coverage(pkg, br) = shield("coveralls", org, pkg, br, label="Coveralls_$br") * "(https://coveralls.io/github/$org/$pkg?branch=$br)"

docs(pkg) = shield("badge/docs-latest-3f51b5.svg", label="docs") * "($docurl/$pkg/latest)"

Case(s) = uppercase(s[1:1]) * lowercase(s[2:end])

function generate_packages_table(info)

  N = length(info)
  names = [info[i]["name"] for i = 1:N]
  desc  = [info[i]["desc"] for i = 1:N]

  s = ""
  s *= "This is a brief list of the installed packages and their situation.\n"
  s *= "For help, check the docs of each package,
  [gitter](https://gitter.im/JuliaSmoothOptimizers/JuliaSmoothOptimizers) for
  anyone online, or open an issue on GitHub\n"

  for i = 1:N
    pkg = names[i]
    pkg == "$org.github.io" && continue
    println("Preparing $pkg")

    github = "[![](assets/github.png)]($(info[i]["url"]))"
    s *= "## $pkg $github\n\n"
    s *= "$(desc[i])\n"
    s *= "\n"

    for srv in [travis, coverage]
      for br in ["develop", "master"] ∩ info[i]["branches"]
        s *= srv(pkg, br) * " "
      end
      s *= "\n"
    end
    for srv in [appveyor]
      pkg in no_appveyor && continue
      for br in ["develop", "master"] ∩ info[i]["branches"]
        s *= srv(pkg, br) * " "
      end
      s *= "\n"
    end

    # Docs
    if statuscode(get("$docurl/$pkg/latest")) == 200
      s *= "$(docs(pkg))\n"
    end

    s *= "\n"
  end
  return s
end

function generate_home_page()
  open("src/index.md", "w") do f
    write(f, readstring("README.md"))
  end
end

"""
To be used only when information changes. It's slow because it has to
communicate with GitHub too many times
"""
function save_information()
  println("Downloading repos")
  repos = GitHub.repos(org)[1]
  n = length(repos)
  info = [Dict{String,Any}("name"=>get(repos[i].name),
                           "desc"=>get(repos[i].description),
                           "url"=>get(repos[i].html_url)
                          ) for i = 1:n]
  for i = 1:n
    println("Downloading branches of repo $(info[i]["name"])")
    br = branches(repos[i])
    info[i]["branches"] = map(x->get(x.name), br[1])
  end

  JLD.save("github_info.jld", "info", info)
  return info
end

function get_information()
  return load("github_info.jld")["info"]
end

#info = save_information()
info = get_information()
s = generate_packages_table(info)
open("src/status.md", "w") do f
  write(f, s)
end

generate_home_page()
