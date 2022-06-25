@def title = "Sandbox"

# Sandbox

Where I try configuration things.

## rfig

Text before.

```julia:./copy-jso.jl
isdir("plots") || mkdir("plots")
cp("_assets/jso.png", "__site/assets/something.png"; force=true)
print("No errors")
```

<!-- Don't add text between -->

\output{./copy-jso.jl}

Text after. Don't add text between input and output.
Code inline `x = 2`. Also math $\int x$.

{{ rfig something.png JSO logo - testing that rfig works }}

## Icons

We use [Ionicons](https://ionic.io/ionicons), through [Bulma](https://bulma.io/documentation/elements/icon/).
Icons will have to be pure HTML, so wrap it in `~~~` so Franklin doesn't parse it.

Example:
```plaintext
~~~
<span class="icon has-text-info">
<ion-icon name="copy"></ion-icon>
</span>
~~~
```
Generates

~~~
<span class="icon has-text-info">
<ion-icon name="copy"></ion-icon>
</span>
~~~

## Test list_versions

Check sandbox.jl (it is not actually being loaded).

{{ list_versions }}
