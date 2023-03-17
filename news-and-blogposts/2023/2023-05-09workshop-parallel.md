@def title = "Exploring Parallel Computing and GPU Programming with Julia"
@def rss_description = "GERAD Workshop: Exploring Parallel Computing and GPU Programming with Julia."

# GERAD Workshop: Exploring Parallel Computing and GPU Programming with Julia

The Julia programming language is being increasingly adopted in High Performance Computing (HPC) due to its unique way to combine performance with simplicity and interactivity, enabling unprecedented productivity in HPC development.

``` Comment 1:
Add a brief introduction that highlights the importance of parallel computing and GPU programming in high-performance computing, and how Julia is becoming increasingly popular for these applications.
```

``` Comment 2:
Consider including some specific examples of applications or use cases where parallel computing and GPU programming with Julia have been particularly useful or impactful. This could help to make the content more concrete and relatable for readers.
```

```
https://arxiv.org/abs/2211.02740
```

Alexis Montoison, PhD student at Polytechnique Montréal, and main developper of [JuliaSmoothOptimizers/Krylov.jl](https://github.com/JuliaSmoothOptimizers/Krylov.jl), animated a 3hrs workshop on parallel computing and GPU programming with Julia, aimed at users of the Julia language who want to learn more about high-performance computing techniques.

The workshop provided an overview of high-performance computing (HPC) with Julia, with a particular emphasis on parallel computing techniques. Participants learned about three types of parallel computations: multi-threading, distributed computing, and GPU programming. Multi-threading allows tasks to be scheduled simultaneously on more than one thread or CPU core, sharing memory and parallelizing on shared-memory systems. Distributed computing enables multiple Julia processes to run with separate memory spaces on the same or multiple computers. Finally, GPU programming demonstrates how to port a computational procedure to a graphical processing unit (GPU) through either high-level or low-level programming. By mastering these techniques, participants were able to optimize their Julia programs and achieve faster and more efficient computations.

The workshop was supported by two organizations from Montréal, Québec, the GERAD and IVADO, and took place on [March 9th, 2023, at the GERAD](https://www.gerad.ca/en/events/2081). The event was advertised on the GERAD website and the workshop materials can be found on the Github repository: [github.com/amontoison/Workshop-GERAD](https://github.com/amontoison/Workshop-GERAD).

Overall, the workshop provided valuable insights and practical knowledge for those interested in optimizing their Julia programs and improving their parallel computing skills. The workshop material contained a lot of references to learn more on this topic. One particular application of interest for JuliaSmoothOptimizers is to run iterative solvers for linear algebra on GPU, see [juliasmoothoptimizers.github.io/Krylov.jl/dev/gpu/](https://juliasmoothoptimizers.github.io/Krylov.jl/dev/gpu/).

```Comment 3
Use subheadings or bullet points to break up the content into smaller, more digestible sections. This can help readers to quickly scan the post and find the information that is most relevant to them.
```

```Comment 4
Consider including some quotes or testimonials from participants in the workshop, to provide a more personal perspective on the content and help readers to understand how the material might be useful to them.
```

```Comment 5
Include some images or diagrams to illustrate the concepts and techniques discussed in the workshop. This can help to make the content more engaging and easier to understand.
```
