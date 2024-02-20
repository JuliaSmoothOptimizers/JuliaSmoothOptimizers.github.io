@def title = "References"

~~~
<script>
new ClipboardJS('.copy-ref');
</script>
~~~

# Publications, talks and other references

If you use JSO, we ask that you cite us. In addition to any specific reference that may suggested by the packages you are using, we also ask you to cite JSO using the format given in [Organization/CITATION.cff](https://github.com/JuliaSmoothOptimizers/Organization/blob/main/CITATION.cff).

```plaintext
@software{The_JuliaSmoothOptimizers_Ecosystem,
author = {Migot, Tangi and Orban, Dominique and Soares Siqueira, Abel and contributors},
license = {MPL-2.0},
month = feb,
title = {{The JuliaSmoothOptimizers Ecosystem for Numerical Linear Algebra and Optimization in Julia}},
doi = {10.5281/zenodo.2655082},
url = {https://jso.dev},
year = {2024}
}
```

```julia:./list-publications.jl
#hideall
using Bibliography, JSON

function bib_string(
  authors,
  title,
  where,
  date,
  link=nothing;
  isdoi=false,
)
  if !isdoi && link != nothing
    title = "[$title]($link)"
  end
  V = [title, "**$(authors)**", where]
  if date != ""
    push!(V, date)
  end
  if isdoi
    short_link = replace(link, "https://doi.org/" => "")
    push!(V, "[$(short_link)]($link)")
  end
  str = join(V, ", ")
  str = replace(str, "{" => "", "}" => "", "\\'e" => "é", "\\student" => "")
  return str
end

function icon(cite)
  """~~~
  <button data-clipboard-text="$(cite)" class="copy-ref">
  <span class="icon is-small has-text-primary">
  <ion-icon size="small" name="copy"></ion-icon>
  </span>
  </button>
  ~~~"""
end

bib = vcat(bibtex_to_web.("_data/bibtex/" .* readdir("_data/bibtex/"))...)
json = JSON.parsefile("_data/references.json")
json = sort(json, by=x->x["date"], rev=true)

for (type_, title) in [
    ("book", "Books"),
    ("article", "Articles"),
    ("techreport", "Technical Reports"),
    ("inproceedings", "In Proceedings"),
  ]
  selected = sort(filter(x -> x.type == type_, bib), by=x -> x.year, rev=true)
  length(selected) == 0 && continue

  if length(selected) > 1
    println("### $title ($(length(selected)))")
  else
    println("### $title")
  end

  for v in selected
    str = bib_string(v.names, v.title, v.in, "", v.link, isdoi=true)


    println("- " * icon(v.cite) * str)
  end
end

for (type_, title) in [
    ("talk", "Talks"),
    ("classes", "Classes"),
  ]
  selected = filter(x -> x["type"] == type_, json)
  length(selected) == 0 && continue

  if length(selected) > 1
    println("### $title ($(length(selected)))")
  else
    println("### $title")
  end

  for v in selected
    str = bib_string(v["author"], v["title"], v["where"], Dates.format(Date(v["date"]), "yyyy-u-d"), get(v, "link", nothing))
    println("- " * str)
  end
end
```

~~~
<div class="references">
~~~

\textoutput{./list-publications.jl}

~~~
</div>
~~~
