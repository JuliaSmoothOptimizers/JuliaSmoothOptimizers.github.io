# This file was generated, do not modify it. # hide
#hideall
using JSON
data = JSON.parsefile("_data/bib.json")
for key in ["Books", "Publications", "Talks", "Classes"]
  println("### $key")
  for d in filter(x -> x["key"] == key, data)
    url = getkey(d, "link", nothing)
    if url === nothing
      print("- $(d["title"]), ")
    else
      print("- [🌐 $(d["title"])]($url), ")
    end
    println(join([d["author"], d["date"], d["where"]], ", "))
  end
end