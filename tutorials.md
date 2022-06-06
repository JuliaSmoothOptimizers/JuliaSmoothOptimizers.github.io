@def title = "Tutorials"
@def load_tutorial_script = true

# Tutorials and how-to guides

This is a curated list of tutorials.

~~~
<button id="show-tags-btn" onclick="toggle_show_tags()" class="button is-small is-primary mt-2">
  <span class="icon is-small">
    <ion-icon name="eye"></ion-icon>
  </span>
  <span>Show tags</span>
</button>
~~~
```julia:./list-tags.jl
#hideall
using JSON
data = JSON.parsefile("_data/docs.json")
tags = String[]
pkgs = String[]
for entry in data
  global tags, pkgs
  tags = union(tags, entry["tags"])
  pkgs = union(pkgs, entry["pkgs"])
end
tags = sort(unique(tags))
pkgs = sort(unique(pkgs))

println("""
~~~
<div id="tags" class="is-height-zero">
<button onclick="list_tutorials()" class="button is-small is-primary mt-2">
  <span class="icon is-small">
    <ion-icon name="ban"></ion-icon>
  </span>
  <span>Clear selection</span>
</button>
~~~""")

for tag in tags
  println("""~~~<button onclick="tags_click('$tag')" class="button is-small is-link is-outlined mt-2">
    <span class="icon is-small">
      <ion-icon name="pricetag"></ion-icon>
    </span>
    <span>$tag</span>
  </button>
  ~~~""")
end

for pkg in pkgs
  println("""~~~
  <button onclick="pkgs_click('$pkg')" class="button is-small is-danger is-outlined mt-2">
  <span class="icon is-small">
    <ion-icon name="cube"></ion-icon>
  </span>
  <span>$pkg.jl</span>
  </button>
  ~~~""")
end
```
\textoutput{./list-tags}
~~~
</div> <!-- End of tags -->
~~~

---

~~~
<div id="tutorials-output">
</div>
~~~

---

```julia:./list-docs.jl
#hideall
using JSON
data = JSON.parsefile("_data/docs.json")
data = sort(data, by=x->x["date"], rev=true)
for entry in data
  title, repo, short = entry["title"], entry["repo"], entry["short"]
  link = "https://jso-docs.github.io/$repo"
  println("""~~~
  <div class="news-item">
    <a href="$link">
      <span class="is-size-4 has-text-primary">
        $title
      </span>
      <br>
      <p class="has-text-grey-dark is-size-6">
        $short
      </p>
    </a>~~~""")
  for tag in entry["tags"]
    println("""~~~
    <button class="button is-small is-link is-outlined">
      <span class="icon is-small">
        <ion-icon name="pricetag"></ion-icon>
      </span>
      <span>$tag</span>
    </button>
    ~~~""")
  end
  println("""~~~
  </div>
  ~~~""")
end
```


<!-- \textoutput{./list-docs} -->

## External tutorials

This is another list of tutorials, from outside sources.

- [Abel Siqueira's YouTube playlist on JSO Tutorials](https://www.youtube.com/playlist?list=PLOOY0eChA1uxmm8G2caFpdX7X9NjgpDUY), Abel Soares Siqueira, 08 April 2020
- [NLPModels.jl and CUTEst.jl: Constrained Optimization](https://abelsiqueira.github.io/blog/_posts/2017/2017-02-17-nlpmodelsjl-and-cutestjl-constrained-optimization/), Abel Soares Siqueira, 17 February 2017
- [NLPModels.jl, CUTEst.jl and other Nonlinear Optimization Packages on Julia](https://abelsiqueira.github.io/blog/_posts/2017/2017-02-07-nlpmodelsjl-cutestjl-and-other-nonlinear-optimization-packages-on-julia/), Abel Soares Siqueira, 07 February 2017