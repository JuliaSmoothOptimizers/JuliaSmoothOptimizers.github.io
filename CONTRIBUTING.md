# How to contribute with a tutorial or how-to guide.

1. Find out whether you're working on a tutorial or a how-to guide. See [here](https://documentation.divio.com) for more details.
2. Mention your plans of writing a tutorial/how-to guide, either in an issue, or on open a [discussion](https://github.com/JuliaSmoothOptimizers/Organization/discussions).
3. Write a `.jl` script with comments. The comments will be parsed. Look into [_literate](_literate/) for examples.
4. Write the corresonding `.md` file. Look into [pages](pages/).
5. To compile, activate this folder, run `using Franklin`, then `serve()`.
6. Create your pull request.