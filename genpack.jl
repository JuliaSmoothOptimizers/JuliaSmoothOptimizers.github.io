using GitHub

const org = "JuliaSmoothOptimizers"
const docurl = "https://$org.github.io"
const shieldurl = "https://img.shields.io"
const style = "?style=flat" # flat, flat-square or plastic

shield(args; label="") = "[![]($shieldurl/$args$style&label=$label)]"
shield(svc, org, pkg; label="") = shield("$svc/$org/$pkg.svg", label=label)
shield(svc, org, pkg, br; label="") = shield(svc, org, "$pkg/$br", label=label)

APV(pkg) = lowercase(replace(pkg, ".", "-"))

travis(pkg, br) = shield("travis", org, pkg, br, label="Travis_$br") * "(https://travis-ci.org/$org/$pkg)"
appveyor(pkg, br) = shield("appveyor/ci", "dpo", APV(pkg), br, label="Appveyor_$br") * "(https://ci.appveyor.com/project/dpo/$(APV(pkg))/branch/$br)"
coverage(pkg, br) = shield("coveralls", org, pkg, br, label="Coveralls_$br") * "(https://coveralls.io/github/$org/$pkg?branch=$br)"

docs(pkg) = shield("badge/docs-latest-ff5722.svg", label="docs") * "($docurl/$pkg/latest)"
gitter(pkg) = shield("gitter/room", org, pkg) * "(https://gitter.im/$org/$pkg)"

Case(s) = uppercase(s[1:1]) * lowercase(s[2:end])

function generate_packages_table(repos)

  N = length(repos)
  names = [get(repos[i].name) for i = 1:N]
  desc  = [get(repos[i].description) for i = 1:N]

  s = ""
  for i = 1:N
    pkg = names[i]
    pkg == "$org.github.io" && continue

    s *= "## $pkg []($(get(repos[i].html_url))){ .icon .icon-github }\n\n"
    s *= "$(desc[i])\n"
    s *= "\n"

    for srv in [travis, appveyor, coverage]
      s *= "- "
      for br in ["develop", "master"]
        s *= srv(pkg, br) * " "
      end
      s *= "\n"
    end
    for srv in [docs, gitter]
      s *= " - $(srv(pkg))\n"
    end

    s *= "\n"
  end
  return s
end

function generate_home_page(repos)
  N = length(repos)
  names = [get(repos[i].name) for i = 1:N]
  desc  = [get(repos[i].description) for i = 1:N]

  open("src/index.md", "w") do f
    write(f, readstring("README.md"))

    write(f, "\n")
    for i = 1:N
      pkg = names[i]
      pkg == "$org.github.io" && continue
      write(f, "- [**$pkg**](packages/#$(lowercase(replace(pkg,".","")))): $(desc[i])\n")
    end
  end
end

#repos = GitHub.repos(org)[1]
s = generate_packages_table(repos)
open("src/packages.md", "w") do f
  write(f, s)
end

generate_home_page(repos)
