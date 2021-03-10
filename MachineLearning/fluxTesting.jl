import Pkg; Pkg.add("Flux")

using Flux 
f(x) = 3x^2 + 2x + 1
df(x) = gradient(f, x)[1]; # df/dx = 6x + 2
df(2)
d2f(x) = gradient(df, x)[1]; # d²f/dx² = 6
d2f(2)