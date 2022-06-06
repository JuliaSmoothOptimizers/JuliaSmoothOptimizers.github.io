# Julia Smooth Optimizers Docs

Curated repository of tutorials regarding all things [JSO](https://github.com/JuliaSmoothOptimizers/).

[![](https://img.shields.io/badge/go_to-site-3f51b5.svg)](https://jso-docs.github.io)

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for a full description.

## Development guide

- Install `npm`
- Run `npm install`
- Run `npm run css-build -- --watch`
- Open julia, activate and instantiate the environment.
  ```
  julia> # press ]
  pkg> activate .
  (...) pkg> instantiate
  ```
- Use `Franklin` and `serve`
  ```
  pkg> # press backspace
  julia> using Franklin
  julia> serve()
  ```
- Go to https://localhost:8000 to check that everything is running
- Create a branch for your work (`git checkout -b mybranch`)
- Work, make a commit, push
- Make a Pull Request. An automatic preview should be generated.