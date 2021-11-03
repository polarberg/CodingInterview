### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ aad1798c-72d3-4970-a1fa-84f7b8fd0361
using PlutoUI

# ╔═╡ 1c6fb2b7-20bf-4913-a2f3-784c00583617
A = [complex(0)]

# ╔═╡ 49b5aef0-ea57-11eb-07a7-ed2bc7ae074f
function n_steps(c::Complex) # number of steps interating 0 under z^2 +c until >2 
    m(z) = z^2 + c 
    start = 0
	cnt = 0 
    A = m(start)
    for i in 1:2^31
		cnt += 1 
        if real(A) > 2.0
            return cnt
        else 
            A = m(A)
		end 
	end
end 

# ╔═╡ 2012e050-a5e7-487f-9974-0b5745b2437e


# ╔═╡ a3994987-6ae3-4694-966b-db7e1b50ae49
@bind digits Slider(float(range(-10.0,stop=-0.0,step=2.0)))

# ╔═╡ 5e9c727c-8b9a-4993-942e-44dd22be551e
[n_steps(1/4+10^i+0im) for i in range(-16.0,stop=-0.0,step=2.0)]

# ╔═╡ 9bdd828a-ffcc-4b2b-8f34-736e84e5b535
[ i for i in range(10.0,stop=-10.0,step=-2.0) ] 

# ╔═╡ df6c8263-3e11-427e-98fb-42e3a32bcbea


# ╔═╡ 373d7b4f-b089-4004-9e98-06bc8beb9c79


# ╔═╡ d8409199-454f-4322-b35e-564f61972dce


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "c8abc88faa3f7a3950832ac5d6e690881590d6dc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.0"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═aad1798c-72d3-4970-a1fa-84f7b8fd0361
# ╠═1c6fb2b7-20bf-4913-a2f3-784c00583617
# ╠═49b5aef0-ea57-11eb-07a7-ed2bc7ae074f
# ╠═2012e050-a5e7-487f-9974-0b5745b2437e
# ╠═a3994987-6ae3-4694-966b-db7e1b50ae49
# ╠═5e9c727c-8b9a-4993-942e-44dd22be551e
# ╠═9bdd828a-ffcc-4b2b-8f34-736e84e5b535
# ╠═df6c8263-3e11-427e-98fb-42e3a32bcbea
# ╠═373d7b4f-b089-4004-9e98-06bc8beb9c79
# ╠═d8409199-454f-4322-b35e-564f61972dce
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
