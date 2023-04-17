# This file was generated, do not modify it. # hide
isdir("plots") || mkdir("plots")
cp("_assets/jso.png", "__site/assets/something.png"; force=true)
print("No errors")