# This file was generated, do not modify it. # hide
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