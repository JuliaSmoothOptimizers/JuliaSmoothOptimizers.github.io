using Pkg, Markdown, JSON

const jso_pkgs = [
  "ADNLPModels",
  "AMD",
  "AmplNLReader",
  "BasicLU",
  "BenchmarkProfiles",
  "BundleAdjustmentModels",
  "CaNNOLeS",
  "CUTEst",
  "DCISolver",
  "HSL",
  "JSOSolvers",
  "Krylov",
  "LDLFactorizations",
  "LimitedLDLFactorizations",
  "LinearOperators",
  "LLSModels",
  "ManualNLPModels",
  "MUMPS",
  "NLPModels",
  "NLPModelsIpopt",
  "NLPModelsJuMP",
  "NLPModelsKnitro",
  "NLPModelsModifiers",
  "NLPModelsTest",
  "NLSProblems",
  "OptimizationProblems",
  "PDENLPModels",
  "Percival",
  "PROPACK",
  "QPSReader",
  "QRMumps",
  "QuadraticModels",
  "RipQP",
  "SolverBenchmark",
  "SolverCore",
  "SolverTest",
  "SolverTools",
  "SparseMatricesCOO",
  "SuiteSparseMatrixCollection",
]

function badge(name, version)
  color, lbl_color = if name in jso_pkgs
    h = div(360 * findfirst(name .== jso_pkgs), length(jso_pkgs))
    "hsl($h,100%25,30%25)", "hsl($h,30%25,30%25)"
  elseif version == "STDLIB"
    "666", "444"
  else
    "666", "999"
  end

  badge_img = "<img class=\"badge\" src=\"https://img.shields.io/badge/$name-$version-$color?style=flat-square&labelColor=$lbl_color\">"
  if name in jso_pkgs
    link = "https://juliasmoothoptimizers.github.io/$name.jl/stable/"
    "<a href=\"$link\">$badge_img</a>"
  else
    badge_img
  end
end

function hfun_list_versions()
  lt_file = locvar("fd_rpath")[1:end-2] * "jl"
  if !isfile(lt_file)
    lt_file = lt_file[1:end-2] * "md"
  end
  if !isfile(lt_file)
    error("$lt_file does not exist")
  end
  lines = readlines(lt_file)
  pkgs = String[]
  for line in lines
    if match(r"^using", line) !== nothing
      sline = split(line[7:end], ", ")
      append!(pkgs, sline)
    end
  end
  pkgs = unique(sort(pkgs))
  out = ""
  for pkg in pkgs
    if pkg in jso_pkgs
      out *= badge(pkg, "JSO") * "\n"
    elseif pkg in readdir(Base.Sys.STDLIB)
      out *= badge(pkg, "STDLIB") * "\n"
    end
  end
  out
end

function aux_latest()
  data = JSON.parsefile("_data/tutorials.json")
  data = sort(data, by=x->x["date"], rev=true)
  data[1]
end

hfun_latest_link()  = aux_latest()["link"]
hfun_latest_short() = aux_latest()["short"]
hfun_latest_title() = aux_latest()["title"]

function hfun_rfig(params)
  # Building locally or the main site shouldn't add the link
  repo = split(get(ENV, "GITHUB_REPOSITORY", "nothing/JuliaSmoothOptimizers.github.io"), "/")[2]
  if repo == "JuliaSmoothOptimizers.github.io"
    repo = ""
  end
  file = "/" * joinpath(repo, "assets", params[1])
  caption = join(params[2:end], " ")
  """
  <figure>
    <img class=\"image\" src=\"$file\">
    <figcaption>$caption</figcaption>
  </figure>
  """
end

@delay function hfun_list_news()
  output = ""
  for year in sort(readdir("news-and-blogposts"), rev=true)
    for post in sort(readdir("news-and-blogposts/$year"), rev=true)
      filename = "news-and-blogposts/$year/$post"
      link = "/" * splitext(filename)[1] * "/"
      title = pagevar(filename, :title)
      date = basename(filename)[1:10]
      excerpt = pagevar(filename, :rss_description)

      output *= """
      <div class="news-item">
        <a href="$link">
          <span class="is-size-7 has-text-grey-dark">
            $date
          </span>
          <br>
          <span class="is-size-4 has-text-primary">
            $title
          </span>
          <br>
          <span class="has-text-grey-dark">
            $excerpt
          </span>
        </a>
      </div>
      """
    end
  end
  return output
end

@delay function hfun_list_news_short()
  year = sort(readdir("news-and-blogposts"), rev=true)[1]
  post = sort(readdir("news-and-blogposts/$year"), rev=true)[1]
  filename = "news-and-blogposts/$year/$post"
  link = "/" * splitext(filename)[1] * "/"
  title = pagevar(filename, :title)
  date = basename(filename)[1:10]
  excerpt = pagevar(filename, :rss_description)

  output = """
  <div class="news-item">
    <a href="$link">
      <span class="is-size-7 has-text-grey-dark">
        $date
      </span>
      <br>
      <span class="is-size-4 has-text-primary">
        $title
      </span>
      <br>
      <p class="has-text-grey-dark is-size-6">
        $excerpt
      </p>
    </a>
  </div>
  """
  return output
end

function hfun_process_tutorials_data()
  json = JSON.parsefile("_data/tutorials.json")
  json = sort(json, by=x->x["date"], rev=true)
  data = "const data = " * JSON.json(json)
  return """<script type="text/javascript">
  $(join(data))
  </script>"""
end
