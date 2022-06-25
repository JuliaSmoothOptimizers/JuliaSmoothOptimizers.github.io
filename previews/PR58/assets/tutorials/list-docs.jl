# This file was generated, do not modify it. # hide
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