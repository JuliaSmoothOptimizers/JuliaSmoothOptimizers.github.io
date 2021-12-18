# This file was generated, do not modify it. # hide
#hideall
using JSON
data = JSON.parsefile("_data/bib.json")
data = sort(data, by=x->x["date"])
for key in ["Books", "Publications", "Talks", "Classes"]
  println("### $key")
  for d in filter(x -> x["key"] == key, data)
    url = get(d, "link", nothing)
    if url === nothing
      print("- $(d["title"]), ")
    else
      print("- [$(d["title"])]($url), ")
    end
    D = Dates.format(Date(d["date"]), "yyyy-u-d")
    println(join([d["author"], "_$(D)_", d["where"]], ", "))
  end
end