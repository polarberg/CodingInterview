### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 0856ada0-b425-11eb-0d94-051fb2ae589e
using Plots, BenchmarkTools

# ╔═╡ 93aa1f80-fcf1-44f3-91fa-4c1ce2d48c69
T = 0:0.01:1 #range 

# ╔═╡ 51cf528e-2d21-433e-ab76-0a5df7ebdb3e
#log2(1+x) ≈ x + μ

# ╔═╡ 397b2c4c-a6e5-45e4-9fae-14f973b93a48
μ = 0.0430

# ╔═╡ 072d2556-cb77-4c36-949b-dc50e5533296
begin
	plot(x -> log2(1+x),T)
	plot!(T,T)
	plot!(x -> x + μ,T)
end

# ╔═╡ 439b9bbb-abe5-4545-a4f0-a3fbc695a0b0
plot(x->log2(1+x)-x, T)

# ╔═╡ 35bfc990-a14a-44fd-8f4d-c14d7e747b76


# ╔═╡ Cell order:
# ╠═0856ada0-b425-11eb-0d94-051fb2ae589e
# ╠═93aa1f80-fcf1-44f3-91fa-4c1ce2d48c69
# ╠═51cf528e-2d21-433e-ab76-0a5df7ebdb3e
# ╠═397b2c4c-a6e5-45e4-9fae-14f973b93a48
# ╠═072d2556-cb77-4c36-949b-dc50e5533296
# ╠═439b9bbb-abe5-4545-a4f0-a3fbc695a0b0
# ╠═35bfc990-a14a-44fd-8f4d-c14d7e747b76
