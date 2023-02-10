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
