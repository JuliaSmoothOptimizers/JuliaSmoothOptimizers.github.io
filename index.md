@def title = "JuliaSmoothOptimizers"

# Julia Smooth Optimizers

\tableofcontents

Julia Smooth Optimizers (JSO) is an organization on GitHub containing a collection of Julia packages for Nonlinear Optimization software development, testing, and benchmarking.
We provide tools for building models, access to repositories of problems, subproblem solving, linear algebra, and solving problems.
This site will serve as the repository of information about JSO and its packages.

## Documentation resources

We divide our (incomplete) documentation resources in 4 parts, following the idea of [Divio](https://documentation.divio.com):

- [Tutorials](/pages/tutorials/list/): Learning-oriented guides.
- [How-to guides](/pages/how-to/list/): Goal-oriented guides.
- [Reference guides](/pages/reference/list/): Technical reference.
- [Ecosystem discussion](/pages/ecosystem/list/): Understanding-oriented.

Additionally, we have a [wiki](https://github.com/JuliaSmoothOptimizers/Organization/wiki), mostly focused to our students.

## Bug reports and discussions

If you think you found a bug in any of our packages, feel free to open an issue at the specific GitHub repo.
If should be a link like `https://github.com/JuliaSmoothOptimizers/PACKAGE.jl`.

Focused suggestion and requests can also be opened as issues.
Before opening a pull request, start an issue or a discussion on the topic, please.

If you want to ask a question that is not suited for a bug report, feel free to start a discussion [here](https://github.com/JuliaSmoothOptimizers/Organization/discussions).
This forum is for general discussion, so questions about any of our packages are welcome.

## Publications, talks and other references

If you use JSO, we ask that you cite us. In addition to any specific reference that may suggested by the packages you are using, we also ask you to cite:

**JuliaSmoothOptimizers**. Dominique Orban and Abel Soares Siqueira. Zenodo. Apr, 2019. [10.5281/zenodo.2655082](https://doi.org/10.5281/zenodo.2655082)
```plaintext
@Misc{jso-2019,
  author = {D. Orban and A. S. Siqueira},
  title = {{JuliaSmoothOptimizers}: Infrastructure and Solvers for Continuous Optimization in {J}ulia},
  doi = {10.5281/zenodo.2655082},
  URL = {https://juliasmoothoptimizers.github.io},
  year = {2019},
}
```

```julia:./list-publications.jl
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
```
\textoutput{./list-publications}