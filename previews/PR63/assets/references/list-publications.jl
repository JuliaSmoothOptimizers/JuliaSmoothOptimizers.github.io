# This file was generated, do not modify it. # hide
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
    push!(V, "[$link]($link)")
  end
  str = join(V, ", ")
  str = replace(str, "{" => "", "}" => "", "\\'e" => "é", "\\student" => "", "https://doi.org/" => "")
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
    ("techreport", "Technical Reports")
  ]
  selected = sort(filter(x -> x.type == type_, bib), by=x -> x.year, rev=true)
  length(selected) == 0 && continue

  println("### $title")

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

  println("### $title")

  for v in selected
    str = bib_string(v["author"], v["title"], v["where"], Dates.format(Date(v["date"]), "yyyy-u-d"), get(v, "link", nothing))
    println("- " * str)
  end
end