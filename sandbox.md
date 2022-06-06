@def title = "Sandbox"

# Sandbox

Where I try configuration things.

## rfig

```julia:./copy-jso.jl
isdir("plots") || mkdir("plots")
cp("_assets/jso.png", "__site/assets/something.png"; force=true)
print("No errors")
```

\output{./copy-jso.jl}

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
