### A Pluto.jl notebook ###
# v0.14.7

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

# ╔═╡ 2dcb18d0-0970-11eb-048a-c1734c6db842
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Plots", version="1"),
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
    ])
    using Plots, PlutoUI, LinearAlgebra
end

# ╔═╡ 19fe1ee8-0970-11eb-2a0d-7d25e7d773c6
md"_homework 9, version 1_"

# ╔═╡ 49567f8e-09a2-11eb-34c1-bb5c0b642fe8
# hello there

# ╔═╡ 181e156c-0970-11eb-0b77-49b143cc0fc0
md"""

# **Homework 9**: _Epidemic modeling III_
`18.S191`, Spring 2021

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 1f299cc6-0970-11eb-195b-3f951f92ceeb
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Austin Nguyen", kerberos_id = "polarberg")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ 1bba5552-0970-11eb-1b9a-87eeee0ecc36
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 2848996c-0970-11eb-19eb-c719d797c322
md"_Let's create a package environment:_"

# ╔═╡ 69d12414-0952-11eb-213d-2f9e13e4b418
md"""
In this problem set, we will look at a simple **spatial** agent-based epidemic model: agents can interact only with other agents that are *nearby*.  (In Homework 7, any agent could interact with any other, which is not realistic.)

A simple approach is to use **discrete space**: each agent lives
in one cell of a square grid. For simplicity we will allow no more than
one agent in each cell, but this requires some care to
design the rules of the model to respect this.

We will adapt some functionality from Homework 7. You should copy and paste your code from that homework into this notebook.
"""

# ╔═╡ 3e54848a-0954-11eb-3948-f9d7f07f5e23
md"""
## **Exercise 1:** _Wandering at random in 2D_

In this exercise we will implement a **random walk** on a 2D lattice (grid). At each time step, a walker jumps to a neighbouring position at random (i.e. chosen with uniform probability from the available adjacent positions).

"""

# ╔═╡ 3e623454-0954-11eb-03f9-79c873d069a0
md"""
#### Exercise 1.1
We define a struct type `Coordinate` that contains integers `x` and `y`.
"""

# ╔═╡ 0ebd35c8-0972-11eb-2e67-698fd2d311d2
struct Coordinate 
    x::Int
    y::Int
end

# ╔═╡ 027a5f48-0a44-11eb-1fbf-a94d02d0b8e3
md"""
👉 Construct a `Coordinate` located at the origin.
"""

# ╔═╡ b2f90634-0a68-11eb-1618-0b42f956b5a7
origin = Coordinate(0,0)

# ╔═╡ 3e858990-0954-11eb-3d10-d10175d8ca1c
md"""
👉 Write a function `make_tuple` that takes an object of type `Coordinate` and returns the corresponding tuple `(x, y)`. Boring, but useful later!
"""

# ╔═╡ 189bafac-0972-11eb-1893-094691b2073c
function make_tuple(c::Coordinate)
    
    return (c.x,c.y)
end

# ╔═╡ 73ed1384-0a29-11eb-06bd-d3c441b8a5fc
md"""
#### Exercise 1.2
In Julia, operations like `+` and `*` are just functions, and they are treated like any other function in the language. The only special property you can use the _infix notation_: you can write
```julia
1 + 2
```
instead of 
```julia
+(1, 2)
```
_(There are [lots of special 'infixable' function names](https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm#L23-L24) that you can use for your own functions!)_

When you call it with the prefix notation, it becomes clear that it really is 'just another function', with lots of predefined methods.
"""

# ╔═╡ 96707ef0-0a29-11eb-1a3e-6bcdfb7897eb
+(1, 2)

# ╔═╡ b0337d24-0a29-11eb-1fab-876a87c0973f
+

# ╔═╡ 9c9f53b2-09ea-11eb-0cda-639764250cee
md"""
> #### Extending + in the wild
> Because it is a function, we can add our own methods to it! This feature is super useful in general languages like Julia and Python, because it lets you use familiar syntax (`a + b*c`) on objects that are not necessarily numbers!
> 
> One example we've see before is the `RGB` type in the first lectures. You are able to do:
> ```julia
> 0.5 * RGB(0.1, 0.7, 0.6)
> ```
> to multiply each color channel by $0.5$. This is possible because `Images.jl` [wrote a method](https://github.com/JuliaGraphics/ColorVectorSpace.jl/blob/06d70b8a28f5c263f52e414745c2066ccb72b518/src/ColorVectorSpace.jl#L207):
> ```julia
> *(::Real, ::AbstractRGB)::AbstractRGB
> ```

👉 Implement addition on two `Coordinate` structs by adding a method to `Base.:+`
"""

# ╔═╡ e24d5796-0a68-11eb-23bb-d55d206f3c40
function Base.:+(a::Coordinate, b::Coordinate)
    
    return Coordinate(a.x + b.x, a.y + b.y)
end

# ╔═╡ ec8e4daa-0a2c-11eb-20e1-c5957e1feba3
Coordinate(3,4) + Coordinate(10,10) # uncomment to check + works

# ╔═╡ e144e9d0-0a2d-11eb-016e-0b79eba4b2bb
md"""
_Pluto has some trouble here, you need to manually re-run the cell above!_
"""

# ╔═╡ 71c358d8-0a2f-11eb-29e1-57ff1915e84a
md"""
#### Exercise 1.3
In our model, agents will be able to walk in 4 directions: up, down, left and right. We can define these directions as `Coordinate`s.
"""

# ╔═╡ 5278e232-0972-11eb-19ff-a1a195127297
possible_moves = [
	Coordinate( 1, 0), 
	Coordinate( 0, 1), 
	Coordinate(-1, 0), 
	Coordinate( 0,-1),
]

# ╔═╡ 71c9788c-0aeb-11eb-28d2-8dcc3f6abacd
md"""
👉 `rand(possible_moves)` gives a random possible move. Add this to the coordinate `Coordinate(4,5)` and see that it moves to a valid neighbor.
"""

# ╔═╡ 69151ce6-0aeb-11eb-3a53-290ba46add96
+(Coordinate(4,5), rand(possible_moves))

# ╔═╡ 3eb46664-0954-11eb-31d8-d9c0b74cf62b
md"""
We are able to make a `Coordinate` perform one random step, by adding a move to it. Great!

👉 Write a function `trajectory` that calculates a trajectory of a `Wanderer` `w` when performing `n` steps., i.e. the sequence of positions that the walker finds itself in.

Possible steps:
- Use `rand(possible_moves, n)` to generate a vector of `n` random moves. Each possible move will be equally likely.
- To compute the trajectory you can use either of the following two approaches:
  1. 🆒 Use the function `accumulate` (see the live docs for `accumulate`). Use `+` as the function passed to `accumulate` and the `w` as the starting value (`init` keyword argument). 
  1. Use a `for` loop calling `+`. 

"""

# ╔═╡ edf86a0e-0a68-11eb-2ad3-dbf020037019
function trajectory(w::Coordinate, n::Int)	
    rand_moves = rand(possible_moves, n) # gen vec of n random moves, each move equally likely 

    # computing trajectory
	return accumulate(+, rand_moves; init=w)
end

# ╔═╡ 478309f4-0a31-11eb-08ea-ade1755f53e0
function plot_trajectory!(p::Plots.Plot, trajectory::Vector; kwargs...)
	plot!(p, make_tuple.(trajectory); 
		label=nothing, 
		linewidth=2, 
		linealpha=LinRange(1.0, 0.2, length(trajectory)),
		kwargs...)
end

# ╔═╡ 3ebd436c-0954-11eb-170d-1d468e2c7a37
md"""
#### Exercise 1.4
👉 Plot 10 trajectories of length 1000 on a single figure, all starting at the origin. Use the function `plot_trajectory!` as demonstrated above.

Remember from last week that you can compose plots like this:

```julia
let
	# Create a new plot with aspect ratio 1:1
	p = plot(ratio=1)

	plot_trajectory!(p, test_trajectory)      # plot one trajectory
	plot_trajectory!(p, another_trajectory)   # plot the second one
	...

	p
end
```
"""

# ╔═╡ b4d5da4a-09a0-11eb-1949-a5807c11c76c
md"""
#### Exercise 1.5
Agents live in a box of side length $2L$, centered at the origin. We need to decide (i.e. model) what happens when they reach the walls of the box (boundaries), in other words what kind of **boundary conditions** to use.

One relatively simple boundary condition is a **collision boundary**:

> Each wall of the box is a wall, modelled using "collision": if the walker tries to jump beyond the wall, it ends up at the position inside the box that is closest to the goal.

👉 Write a function `collide_boundary` which takes a `Coordinate` `c` and a size $L$, and returns a new coordinate that lies inside the box (i.e. ``[-L,L]\times [-L,L]``), but is closest to `c`. This is similar to `extend_mat` from Homework 1.
"""

# ╔═╡ 0237ebac-0a69-11eb-2272-35ea4e845d84
function collide_boundary(c::Coordinate, L::Number)	
    bounds = -L:L 

    if checkindex(Bool, bounds, c.x) && checkindex(Bool, bounds, c.y) # x,y in bounds 
        return c 
        
    elseif !checkindex(Bool, bounds, c.x) && !checkindex(Bool, bounds, c.y) # both x and y lie outside bounds
        return Coordinate(L*sign(c.x), L*sign(c.y))    # return the nearest corner 

    elseif !checkindex(Bool, bounds, c.x) # y inbounds, x out of bounds 
        return Coordinate(L*sign(c.x), c.y)

    else # y inbounds, x out of bounds
        return Coordinate(c.x, L*sign(c.y))

    end 
end

# ╔═╡ ad832360-0a40-11eb-2857-e7f0350f3b12
collide_boundary(Coordinate(12,4), 10) # uncomment to test

# ╔═╡ b4ed2362-09a0-11eb-0be9-99c91623b28f
md"""
#### Exercise 1.6
👉  Implement a 3-argument method  of `trajectory` where the third argument is a size. The trajectory returned should be within the boundary (use `collide_boundary` from above). You can still use `accumulate` with an anonymous function that makes a move and then reflects the resulting coordinate, or use a for loop.

"""

# ╔═╡ 0665aa3e-0a69-11eb-2b5d-cd718e3c7432
function trajectory(c::Coordinate, n::Int, L::Number)
    rand_moves = rand(possible_moves, n) # gen vec of n random moves, each move equally likely 

    # computing trajectory
	return accumulate( (x,y) -> collide_boundary(+(x, y), L) , rand_moves; init=c)
end

# ╔═╡ 44107808-096c-11eb-013f-7b79a90aaac8
test_trajectory = trajectory(Coordinate(4,4), 30) # test

# ╔═╡ 87ea0868-0a35-11eb-0ea8-63e27d8eda6e
try
	p = plot(ratio=1, size=(650,200))
	plot_trajectory!(p, test_trajectory; color="black", showaxis=false, axis=nothing, linewidth=4)
	p
catch
end

# ╔═╡ 51788e8e-0a31-11eb-027e-fd9b0dc716b5
let
	long_trajectory = trajectory(Coordinate(4,4), 1000)

	p = plot(ratio=1)
	plot_trajectory!(p, long_trajectory)
	p
end

#uncomment to visualize a trajectory

# ╔═╡ dcefc6fe-0a3f-11eb-2a96-ddf9c0891873
let 
    # Create a new plot with aspect ratio 1:1
    p = plot(ratio=1)

    starting_point = (0,0) # all starting at the origin
    num_steps = 1000
    num_plots = 10 

    for i in 1:num_plots
        plot_trajectory!(p, trajectory(Coordinate(starting_point[1],starting_point[2]), num_steps) )  # plot one trajectory
    end 
    
    p
end

# ╔═╡ 903fd22c-a47d-4c74-b6a7-7a71f6c4d0b2
# how to increase range by 10 each time 

# ╔═╡ 1be6f8f0-f8df-46a0-8e57-634d825fc87c
md"

n\_steps $(@bind n_steps Slider(100:200:1500, show_value=true) )
, num\_plots $(@bind num_plots Slider(1:10, show_value=true) )
, bounds $(@bind bounds Slider(10:5:50, show_value=true) )

"

# ╔═╡ 79969ac2-ef82-4245-a787-cd04a566bf7b
let 
    # Create a new plot with aspect ratio 1:1
    p = plot(ratio=1)

    starting_point = (0,0) # all starting at the origin
    num_steps = n_steps
    # num_plots = 4
    # bounds = 20

    for i in 1:num_plots
        plot_trajectory!(p, trajectory(Coordinate(starting_point[1],starting_point[2]), num_steps, bounds) )  # plot one trajectory
    end 
    
    p
end

# ╔═╡ 3ed06c80-0954-11eb-3aee-69e4ccdc4f9d
md"""
## **Exercise 2:** _Wanderering Agents_

In this exercise we will create Agents which have a location as well as some infection state information.

Let's define a type `Agent`. `Agent` contains a `position` (of type `Coordinate`), as well as a `status` of type `InfectionStatus` (as in Homework 4).)

(For simplicity we will not use a `num_infected` field, but feel free to do so!)
"""

# ╔═╡ 1b653338-4406-4313-83a5-ad6ba1b7ec78
abstract type AbstractAgent end 

# ╔═╡ 35537320-0a47-11eb-12b3-931310f18dec
@enum InfectionStatus S I R

# ╔═╡ cf2f3b98-09a0-11eb-032a-49cc8c15e89c
begin 
	mutable struct Agent <: AbstractAgent
    	position::Coordinate
    	status::InfectionStatus
	end
	
	Agent() = Agent(Coordinate(0,0),S)
	Agent(x::Int,y::Int, Status::InfectionStatus) = Agent(Coordinate(x,y), Status)
	Agent(Status::InfectionStatus) = Agent(Coordinate(0,0), Status)
end 

# ╔═╡ 23f252c9-4df8-49e6-a687-05541ad457f1
Agent()

# ╔═╡ 814e888a-0954-11eb-02e5-0964c7410d30
md"""
#### Exercise 2.1
👉 Write a function `initialize` that takes parameters $N$ and $L$, where $N$ is the number of agents and $2L$ is the side length of the square box where the agents live.

It returns a `Vector` of `N` randomly generated `Agent`s. Their coordinates are randomly sampled in the ``[-L,L] \times [-L,L]`` box, and the agents are all susceptible, except one, chosen at random, which is infectious.
"""

# ╔═╡ 0cfae7ba-0a69-11eb-3690-d973d70e47f4
function initialize(N::Number, L::Number)
	# gen vector of N agents coordinates within boundary,
        # initialized to susceptible
    population = [Agent(Coordinate(rand(-L:L),rand(-L:L)), S) for i in 1:N] 

    rand(population).status = I # one agent chosen at random is infectious
	return population
end

# ╔═╡ 0220c8ae-2cea-4c4f-b687-f640d3393d8b
initialize(3, 10)

# ╔═╡ ae2be3cb-4fc2-41cc-a46c-5d7e2436a0ab
length(initialize(3, 10))

# ╔═╡ e0b0880c-0a47-11eb-0db2-f760bbbf9c11
# Color based on infection status
color(s::InfectionStatus) = if s == S
	"blue"
elseif s == I
	"red"
else
	"green"
end

# ╔═╡ b5a88504-0a47-11eb-0eda-f125d419e909
position(a::Agent) = a.position # uncomment this line

# ╔═╡ 87a4cdaa-0a5a-11eb-2a5e-cfaf30e942ca
color(a::Agent) = color(a.status) # uncomment this line

# ╔═╡ bd9973c8-bcf0-4c49-8245-2d2801a47477
status(a::AbstractAgent) = a.status # added

# ╔═╡ 622de9c7-76f9-44c0-90ea-bd97e6d2dbdb
status.(initialize(3, 10))

# ╔═╡ 49fa8092-0a43-11eb-0ba9-65785ac6a42f
md"""
#### Exercise 2.2
👉 Write a function `visualize` that takes in a collection of agents as argument, and the box size `L`. It should plot a point for each agent at its location, coloured according to its status.

You can use the keyword argument `c=color.(agents)` inside your call to the plotting function make the point colors correspond to the infection statuses. Don't forget to use `ratio=1`.
"""

# ╔═╡ f953e06e-099f-11eb-3549-73f59fed8132
md"""

### Exercise 3: Spatial epidemic model -- Dynamics

Last week we wrote a function `interact!` that takes two agents, `agent` and `source`, and an infection of type `InfectionRecovery`, which models the interaction between two agent, and possibly modifies `agent` with a new status.

This week, we define a new infection type, `CollisionInfectionRecovery`, and a new method that is the same as last week, except it **only infects `agent` if `agents.position==source.position`**.
"""	

# ╔═╡ e6dd8258-0a4b-11eb-24cb-fd5b3554381b
abstract type AbstractInfection end

# ╔═╡ de88b530-0a4b-11eb-05f7-85171594a8e8
struct CollisionInfectionRecovery <: AbstractInfection
	p_infection::Float64
	p_recovery::Float64
end

# ╔═╡ 122461d6-4fbd-4952-b255-eba1109afcc3
md" 
##### Old Functions
" 

# ╔═╡ 8029fbe9-32b0-4057-8a18-559b0cb1cb97
function bernoulli(p::Number)
	rand() < p
end

# ╔═╡ ffc3672c-604b-4d44-85aa-dd16b5527131
function set_status!(agent::Agent, new_status::InfectionStatus) # modifies argument 

	agent.status = new_status
end

# ╔═╡ fb89dbd3-e6b5-42b7-b09d-ed451e3e4077
function is_susceptible(agent::Agent)
	
	return agent.status == S 
end

# ╔═╡ 2965e4dc-0d4a-40f7-93f8-a4696136c031
function is_infected(agent::Agent)
	
	return agent.status == I
end

# ╔═╡ 80f39140-0aef-11eb-21f7-b788c5eab5c9
md"""

Write a function `interact!` that takes two `Agent`s and a `CollisionInfectionRecovery`, and:

- If the agents are at the same spot, causes a susceptible agent to communicate the desease from an infectious one with the correct probability.
- if the first agent is infectious, it recovers with some probability
"""

# ╔═╡ 34778744-0a5f-11eb-22b6-abe8b8fc34fd
md"""
#### Exercise 3.1
Your turn!

👉 Write a function `step!` that takes a vector of `Agent`s, a box size `L` and an `infection`. This that does one step of the dynamics on a vector of agents. 

- Choose an Agent `source` at random.

- Move the `source` one step, and use `collide_boundary` to ensure that our agent stays within the box.

- For all _other_ agents, call `interact!(other_agent, source, infection)`.

- return the array `agents` again.
"""

# ╔═╡ 1fc3271e-0a45-11eb-0e8d-0fd355f5846b
md"""
#### Exercise 3.2
If we call `step!` `N` times, then every agent will have made one step, on average. Let's call this one _sweep_ of the simulation.

👉 Create a before-and-after plot of ``k_{sweeps}=1000`` sweeps. 

- Initialize a new vector of agents (`N=50`, `L=40`, `infection` is given as `pandemic` below). 
- Plot the state using `visualize`, and save the plot as a variable `plot_before`.
- Run `k_sweeps` sweeps.
- Plot the state again, and store as `plot_after`.
- Combine the two plots into a single figure using
```julia
plot(plot_before, plot_after)
```
"""

# ╔═╡ 18552c36-0a4d-11eb-19a0-d7d26897af36
pandemic = CollisionInfectionRecovery(0.5, 0.00001)

# ╔═╡ 4e7fd58a-0a62-11eb-1596-c717e0845bd5
@bind k_sweeps Slider(1:10000, default=1000, show_value=true)

# ╔═╡ e964c7f0-0a61-11eb-1782-0b728fab1db0
md"""
#### Exercise 3.3

Every time that you move the slider, a completely new simulation is created an run. This makes it hard to view the progress of a single simulation over time. So in this exercise, we we look at a single simulation, and plot the S, I and R curves.

👉 Plot the SIR curves of a single simulation, with the same parameters as in the previous exercise. Use `k_sweep_max = 10000` as the total number of sweeps.
"""

# ╔═╡ 9c006b31-7c64-4741-b4b6-f676dbf40d6e
function count_SIR(agents::Vector) 
    counts = zeros(Int,1,3)
    for i in agents
        currStatus = status(i)
        if      currStatus == S
            counts[1] += 1 
        elseif  currStatus == I
            counts[2] += 1 
        else  # currStatus == R
            counts[3] += 1 
        end 
    end 

    #return (S=counts[1],I=counts[2],R=counts[3]) # NamedTuple
    return counts
end 

# ╔═╡ 4d83dbd0-0a63-11eb-0bdc-757f0e721221
k_sweep_max = 10000

# ╔═╡ 201a3810-0a45-11eb-0ac9-a90419d0b723
md"""
#### Exercise 3.4 (optional)
Let's make our plot come alive! There are two options to make our visualization dynamic:

👉1️⃣ Precompute one simulation run and save its intermediate states using `deepcopy`. You can then write an interactive visualization that shows both the state at time $t$ (using `visualize`) and the history of $S$, $I$ and $R$ from time $0$ up to time $t$. $t$ is controlled by a slider.

👉2️⃣ Use `@gif` from Plots.jl to turn a sequence of plots into an animation. Be careful to skip about 50 sweeps between each animation frame, otherwise the GIF becomes too large.

This an optional exercise, and our solution to 2️⃣ is given below.
"""

# ╔═╡ 2031246c-0a45-11eb-18d3-573f336044bf
md"""
#### Exercise 3.5
👉  Using $L=20$ and $N=100$, experiment with the infection and recovery probabilities until you find an epidemic outbreak. (Take the recovery probability quite small.) Modify the two infections below to match your observations.
"""

# ╔═╡ a3d5a571-2353-4d64-8721-ff7f2df995d2
md"
p\_i	$(@bind p_i Slider(0.001:0.001:0.05, default=0.001, show_value=true))
, p\_r $(@bind p_r Slider(0.001:0.001:0.01, default=0.001, show_value=true))
"

# ╔═╡ ff66557c-8014-47a8-9656-060d35d4c8b2
testing_Outbreak = CollisionInfectionRecovery(p_i,p_r)

# ╔═╡ 63dd9478-0a45-11eb-2340-6d3d00f9bb5f
causes_outbreak = CollisionInfectionRecovery(0.5, 0.001)

# ╔═╡ 269955e4-0a46-11eb-02cc-1946dc918bfa
does_not_cause_outbreak = CollisionInfectionRecovery(0.5, 0.001)

# ╔═╡ 4d4548fe-0a66-11eb-375a-9313dc6c423d


# ╔═╡ 20477a78-0a45-11eb-39d7-93918212a8bc
md"""
#### Exercise 3.6
👉 With the parameters of Exercise 3.2, run 50 simulations. Plot $S$, $I$ and $R$ as a function of time for each of them (with transparency!). This should look qualitatively similar to what you saw in the previous homework. You probably need different `p_infection` and `p_recovery` values from last week. Why?
"""

# ╔═╡ b1b1afda-0a66-11eb-2988-752405815f95
need_different_parameters_because = md"""
i say so
"""

# ╔═╡ 05c80a0c-09a0-11eb-04dc-f97e306f1603
md"""
## **Exercise 4:** (Optional) _Effect of socialization_

In this exercise we'll modify the simple mixing model. Instead of a constant mixing probability, i.e. a constant probability that any pair of people interact on a given day, we will have a variable probability associated with each agent, modelling the fact that some people are more or less social or contagious than others.
"""

# ╔═╡ b53d5608-0a41-11eb-2325-016636a22f71
md"""
#### Exercise 4.1
We create a new agent type `SocialAgent` with fields `position`, `status`, `num_infected`, and `social_score`. The attribute `social_score` represents an agent's probability of interacting with any other agent in the population.
"""

# ╔═╡ 1b5e72c6-0a42-11eb-3884-a377c72270c7
begin
    mutable struct SocialAgent <: AbstractAgent
        position::Coordinate
        status::InfectionStatus
        num_infected::Int
        social_score::Float64 # agent's probability of interacting with any other agent in the population
    end

    SocialAgent() = SocialAgent(Coordinate(0,0), S, 0, 0)
    SocialAgent(x::Int,y::Int, Status::InfectionStatus) = SocialAgent(Coordinate(x,y), Status,0,0)
    SocialAgent(Status::InfectionStatus) = SocialAgent(Coordinate(0,0), Status,0,0)
end 

# ╔═╡ c704ea4c-0aec-11eb-2f2c-859c954aa520
md"""define the `position` and `color` methods for `SocialAgent` as we did for `Agent`. This will allow the `visualize` function to work. on both kinds of Agents"""

# ╔═╡ fc1d170a-e175-4544-9ccc-8f0bbae6ccd6
position(a::SocialAgent) = a.position

# ╔═╡ 1d0f8eb4-0a46-11eb-38e7-63ecbadbfa20
position.(initialize(3, 10))

# ╔═╡ e97e39aa-0a5d-11eb-3d5f-f90a0acfe5a2
color(a::SocialAgent) = color(a.status)

# ╔═╡ 1ccc961e-0a69-11eb-392b-915be07ef38d
function visualize(agents::Vector, L)

    positions = [(position(i).x,position(i).y) for i in agents]
    c = color.(agents)
    plot(positions, color = c, seriestype = :scatter, title = "Plot", ratio=1,
                 group=status.(agents),lims=[-L,L])
end 

# ╔═╡ 1f96c80a-0a46-11eb-0690-f51c60e57c3f
let
	N = 20
	L = 10
	visualize(initialize(N, L), L) # uncomment this line!
end

# ╔═╡ 474916f2-bb43-4cae-87d5-1ae43a5358b4
social_score(a::SocialAgent) = a.social_score

# ╔═╡ 19e712f5-93df-47d2-a626-9a1a585ab46d
num_infected(a::SocialAgent) = a.num_infected

# ╔═╡ 352f67c3-8f63-4705-8c18-20e375add279
position(SocialAgent())

# ╔═╡ 878c0750-98ce-4395-aed3-449e46a1a1da
color(SocialAgent())

# ╔═╡ 65751ddb-e127-4239-b821-567a29017bdf
social_score(SocialAgent())

# ╔═╡ b554b654-0a41-11eb-0e0d-e57ff68ced33
md"""
👉 Create a function `initialize_social` that takes `N` and `L`, and creates N agents  within a 2L x 2L box, with `social_score`s chosen from 10 equally-spaced between 0.1 and 0.5. (see LinRange)
"""

# ╔═╡ 40c1c1d6-0a69-11eb-3913-59e9b9ec4332
function initialize_social(N, L)
    Agents = []
    SocialScores = LinRange(0.1,0.5,10) # 10 equally spaced between 0.1 and 0.5 

    #initialize
    for i in 1:N # creates N agents 
        push!(Agents, SocialAgent(Coordinate(rand(1:2L),rand(1:2L)),S,0,rand(SocialScores)))
    end 
    rand(Agents).status = I 
    
	return Agents 
end

# ╔═╡ 144524e9-093b-4302-8537-cdd39ef00183
initialize_social(10, 10)

# ╔═╡ 18ac9926-0aed-11eb-034f-e9849b71c9ac
md"""
Now that we have 2 agent types

1. let's create an AbstractAgent type
2. Go back in the notebook and make the agent types a subtype of AbstractAgent.

"""

# ╔═╡ d07b71b3-8c6b-4a97-986e-0d964381a638
function is_susceptible(agent::AbstractAgent)
	
	return agent.status == S 
end

# ╔═╡ 7e03de25-4da2-4ebb-9d09-0b1c0bc6aa36
function is_infected(agent::AbstractAgent)
	
	return agent.status == I
end

# ╔═╡ fbe3f295-6e72-4e0c-8166-cf1ba881f691
function set_status!(agent::AbstractAgent, new_status::InfectionStatus) # modifies argument 
	# your code here
	agent.status = new_status
end

# ╔═╡ 17aa8b9f-a850-4f6a-9782-767625963627
function interact!(agent::Agent, source::Agent, infection::CollisionInfectionRecovery)
    if position(agent) == position(source) 
        if is_susceptible(agent) && is_infected(source) && bernoulli(infection.p_infection) # same spot
            set_status!(agent, I)
        #= # both source and agent can infect each other if infected and the other is susceptible
        elseif is_susceptible(source) && is_infected(agent) && bernoulli(infection.p_infection) # same spot
            set_status!(source, I)
        end 

        if is_infected(agent) && bernoulli(infection.p_recovery)
            set_status!(agent, R)
        end  =#
        end # only source can infect agent 
        if is_infected(agent) && bernoulli(infection.p_recovery)
            set_status!(agent, R)
        end
    end 
end

# ╔═╡ b56ba420-0a41-11eb-266c-719d39580fa9
md"""
#### Exercise 4.2
Not all two agents who end up in the same grid point may actually interact in an infectious way -- they may just be passing by and do not create enough exposure for communicating the disease.

👉 Write a new `interact!` method on `SocialAgent` which adds together the social_scores for two agents and uses that as the probability that they interact in a risky way. Only if they interact in a risky way, the infection is transmitted with the usual probability.
"""

# ╔═╡ 465e918a-0a69-11eb-1b59-01150b4b0f36
function interact!(agent::SocialAgent, source::SocialAgent, infection::CollisionInfectionRecovery)
	if position(agent) == position(source)
        if is_susceptible(agent) && is_infected(source) && bernoulli(agent.social_score + source.social_score)
            set_status!(agent, I)
            source.num_infected += 1
        end 

        if is_infected(agent) && bernoulli(infection.p_recovery)
            set_status!(agent, R)
        end
    end 
end

# ╔═╡ 4c5dd69d-1ef1-434f-bd5c-9c260fb0e819
let 
	as, ai = Agent(),Agent(I)
	interact!(as, ai, CollisionInfectionRecovery(0.8,0.9))
	#interact!(as, ai, CollisionInfectionRecovery(0.8,0.9)) # 2nd if case 
	as, ai
end 

# ╔═╡ 24fe0f1a-0a69-11eb-29fe-5fb6cbf281b8
function step!(agents::Vector, L::Number, infection::AbstractInfection)
	n = length(agents)
    pos = rand(1:n) # position of random agent in vector 
    source = agents[pos]
    source.position = trajectory(position(source),1,L)[1]

    for i in 1:n
        if i == pos # interact on all other agents except n 
            nothing
        else 
            interact!(agents[i], source, infection)
        end 
    end
	
    return agents
end

# ╔═╡ 778c2490-0a62-11eb-2a6c-e7fab01c6822
let
    pandemic = CollisionInfectionRecovery(0.5, 0.1)
	N = 50
	L = 40
	
    agents = initialize(N,L) # initialize vector 

	plot_before = visualize(agents, L)
    
    # run `k_sweeps` k_sweeps
    for i in 1:(N*k_sweeps)
        step!(agents, L, pandemic)
    end 
    plot_after = visualize(agents, L)
	
	plot(plot_before, plot_after)
end

# ╔═╡ 21940771-c6c4-4435-a245-cb955b5b33f1
function sweep!(agents::Vector, L::Number, infection::AbstractInfection)
	for i in 1:size(agents,1)
		step!(agents, L, infection) 
	end 
end

# ╔═╡ 789ee0fe-8f0e-4bfc-b5a7-ca8ae78e22ec
let 
    k_sweep_max = 1000
	N = 50
	L = 40
	pandemic = CollisionInfectionRecovery(0.5, 0.00001)

	agents = initialize(N, L)

	# compute k_sweep_max number of sweeps and plot the SIR
    SIR_vec = count_SIR(agents)
    for i in 2:k_sweep_max
        sweep!(agents, L, pandemic) # runs step!, n times each sweep
        SIR_vec = vcat(SIR_vec, count_SIR(agents)) 
    end 
    SIR_vec
    plot(SIR_vec, color =[color(S) color(I) color(R)], label =["S" "I" "R"], 
            title = "SIR Curves")# # , background_color = "magenta"
end

# ╔═╡ 65af5a0f-1d46-4a84-9332-439e7672ee7e
function SIR_plot_adjust_params(N::Int=50, L::Int=40, pandemic::AbstractInfection=CollisionInfectionRecovery(0.5,0.001), 
                                        k_sweep_max::Int=1000)
	agents = initialize(N, L)

	# compute k_sweep_max number of sweeps and plot the SIR
    SIR_vec = count_SIR(agents)
    for i in 2:k_sweep_max
        sweep!(agents, L, pandemic) # runs step!, n times each sweep
        SIR_vec = vcat(SIR_vec, count_SIR(agents)) 
    end 
    return plot(SIR_vec, color =[color(S) color(I) color(R)], label =["S" "I" "R"], 
            title = "SIR Curves")# # , background_color = "magenta"
end

# ╔═╡ f4ba77a7-0be0-4b43-80ec-829246acc9a1
SIR_plot_adjust_params(100,20,testing_Outbreak, 1000)

# ╔═╡ e5040c9e-0a65-11eb-0f45-270ab8161871
let
    N = 50
    L = 40
    pandemic = CollisionInfectionRecovery(0.5, 0.01)
    
    x = initialize(N, L)
    
    # initialize to empty arrays
    Ss, Is, Rs = Int[], Int[], Int[]
    
    Tmax = 200
    
    @gif for t in 1:Tmax
        for i in 1:50N
            step!(x, L, pandemic)
        end

        #... track S, I, R in Ss Is and Rs
        tmpSIRs = count_SIR(x)
        push!(Ss, tmpSIRs[1])
        push!(Is, tmpSIRs[2])
        push!(Rs, tmpSIRs[3])
        left = visualize(x, L)
    
        right = plot(xlim=(1,Tmax), ylim=(1,N), size=(600,300))
        plot!(right, 1:t, Ss, color=color(S), label="S")
        plot!(right, 1:t, Is, color=color(I), label="I")
        plot!(right, 1:t, Rs, color=color(R), label="R")
    
        plot(left, right)
    end
end

# ╔═╡ 44b73dc0-abfb-47d7-8583-9849ee5d7267
testing_SA = initialize_social(10, 1)

# ╔═╡ 2fab5878-806e-4d6d-92cc-64a3da2fed06
begin
	for i in 1:10
	    step!(testing_SA,1,CollisionInfectionRecovery(0.5,0.01))
	end
	testing_SA
end

# ╔═╡ a885bf78-0a5c-11eb-2383-9d74c8765847
md"""
Make sure `step!`, `position`, `color`, work on the type `SocialAgent`. If `step!` takes an untyped first argument, it should work for both Agent and SocialAgent types without any changes. We actually only need to specialize `interact!` on SocialAgent.

#### Exercise 4.3
👉 Plot the SIR curves of the resulting simulation.

N = 50;
L = 40;
number of steps = 200

In each step call `step!` 50N times.
"""

# ╔═╡ 1f172700-0a42-11eb-353b-87c0039788bd
let
	N = 50
	L = 40
	N_sweeps = 100
    pandemic = CollisionInfectionRecovery(0.1, 0.01)

    global social_agents = initialize_social(N, L)
	
    # initialize to empty arrays
    Ss, Is, Rs = [], [], []
	
	Tmax = 200
	
	@gif for t in 1:Tmax
        # 1. Step! a lot
		for s in 1:N_sweeps
			sweep!(social_agents, L, pandemic)
        end         
		
		# 2. Count S, I and R, push them to Ss Is Rs
        tmpSIRs = count_SIR(social_agents)
        push!(Ss, tmpSIRs[1])
        push!(Is, tmpSIRs[2])
        push!(Rs, tmpSIRs[3])

		# 3. call visualize on the agents,
        left = visualize(social_agents, L)

		# 4. place the SIR plot next to visualize.
        #right = SIR_plot_adjust_params(N, L, pandemic, N_sweeps)
		right = plot(xlim=(1,Tmax), ylim=(1,N), size=(600,300))
        plot!(right, 1:t, Ss, color=color(S), label="S")
        plot!(right, 1:t, Is, color=color(I), label="I")
        plot!(right, 1:t, Rs, color=color(R), label="R")

		# plot(left, right, size=(600,300)) # final plot
        plot(left, right)
	end
end

# ╔═╡ b59de26c-0a41-11eb-2c67-b5f3c7780c91
md"""
#### Exercise 4.4
👉 Make a scatter plot showing each agent's `social_score` on one axis, and the `num_infected` from the simulation in the other axis. Run this simulation several times and comment on the results.
"""

# ╔═╡ faec52a8-0a60-11eb-082a-f5787b09d88c
let 
    N = 50
	L = 50
	N_sweeps = 1000
    pandemic = CollisionInfectionRecovery(0.03, 0.001)

    social_agents = initialize_social(N, L)

    # 1. Step! a lot
	for s in 1:N_sweeps
		sweep!(social_agents, L, pandemic)
    end      
    social_agents
    social_scores_Vec, num_infected_Vec = social_score.(social_agents), num_infected.(social_agents) #x-axis 

    # = # y-axis 
    scatter(social_scores_Vec, num_infected_Vec, xlabel="Social Score", ylabel="Num Infected")
end

# ╔═╡ b5b4d834-0a41-11eb-1b18-1bd626d18934
md"""
👉 Run a simulation for 100 steps, and then apply a "lockdown" where every agent's social score gets multiplied by 0.25, and then run a second simulation which runs on that same population from there.  What do you notice?  How does changing this factor form 0.25 to other numbers affect things?
"""

# ╔═╡ a83c96e2-0a5a-11eb-0e58-15b5dda7d2d2


# ╔═╡ 05fc5634-09a0-11eb-038e-53d63c3edaf2
md"""
## **Exercise 5:** (Optional) _Effect of distancing_

We can use a variant of the above model to investigate the effect of the
mis-named "social distancing"  
(we want people to be *socially* close, but *physically* distant).

In this variant, we separate out the two effects "infection" and
"movement": an infected agent chooses a
neighbouring site, and if it finds a susceptible there then it infects it
with probability $p_I$. For simplicity we can ignore recovery.

Separately, an agent chooses a neighbouring site to move to,
and moves there with probability $p_M$ if the site is vacant. (Otherwise it
stays where it is.)

When $p_M = 0$, the agents cannot move, and hence are
completely quarantined in their original locations.

👉 How does the disease spread in this case?

"""

# ╔═╡ 24c2fb0c-0a42-11eb-1a1a-f1246f3420ff


# ╔═╡ c7649966-0a41-11eb-3a3a-57363cea7b06
md"""
👉 Run the dynamics repeatedly, and plot the sites which become infected.
"""

# ╔═╡ 2635b574-0a42-11eb-1daa-971b2596ce44


# ╔═╡ c77b085e-0a41-11eb-2fcb-534238cd3c49
md"""
👉 How does this change as you increase the *density*
    $\rho = N / (L^2)$ of agents?  Start with a small density.

This is basically the [**site percolation**](https://en.wikipedia.org/wiki/Percolation_theory) model.

When we increase $p_M$, we allow some local motion via random walks.
"""

# ╔═╡ 274fe006-0a42-11eb-1869-29193bb84957


# ╔═╡ c792374a-0a41-11eb-1e5b-89d9de2cf1f9
md"""
👉 Investigate how this leaky quarantine affects the infection dynamics with
different densities.

"""

# ╔═╡ d147f7f0-0a66-11eb-2877-2bc6680e396d


# ╔═╡ 0e6b60f6-0970-11eb-0485-636624a0f9d7
if student.name == "Jazzy Doe"
	md"""
	!!! danger "Before you submit"
	    Remember to fill in your **name** and **Kerberos ID** at the top of this notebook.
	"""
end

# ╔═╡ 0a82a274-0970-11eb-20a2-1f590be0e576
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 0aa666dc-0970-11eb-2568-99a6340c5ebd
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 8475baf0-0a63-11eb-1207-23f789d00802
hint(md"""
After every sweep, count the values $S$, $I$ and $R$ and push! them to 3 arrays. 
""")

# ╔═╡ f9b9e242-0a53-11eb-0c6a-4d9985ef1687
hint(md"""
```julia
let
	N = 50
	L = 40

	x = initialize(N, L)
	
	# initialize to empty arrays
	Ss, Is, Rs = Int[], Int[], Int[]
	
	Tmax = 200
	
	@gif for t in 1:Tmax
		for i in 1:50N
			step!(x, L, pandemic)
		end

		#... track S, I, R in Ss Is and Rs
		
		left = visualize(x, L)
	
		right = plot(xlim=(1,Tmax), ylim=(1,N), size=(600,300))
		plot!(right, 1:t, Ss, color=color(S), label="S")
		plot!(right, 1:t, Is, color=color(I), label="I")
		plot!(right, 1:t, Rs, color=color(R), label="R")
	
		plot(left, right)
	end
end
```
""")

# ╔═╡ 0acaf3b2-0970-11eb-1d98-bf9a718deaee
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ 0afab53c-0970-11eb-3e43-834513e4632e
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ 0b21c93a-0970-11eb-33b0-550a39ba0843
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ 0b470eb6-0970-11eb-182f-7dfb4662f827
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ 0b6b27ec-0970-11eb-20c2-89515ee3ab88
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ ec576da8-0a2c-11eb-1f7b-43dec5f6e4e7
let
	# we need to call Base.:+ instead of + to make Pluto understand what's going on
	# oops
	if @isdefined(Coordinate)
		result = Base.:+(Coordinate(3,4), Coordinate(10,10))

		if result isa Missing
			still_missing()
		elseif !(result isa Coordinate)
			keep_working(md"Make sure that your return a `Coordinate`. 🧭")
		elseif result.x != 13 || result.y != 14
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 0b901714-0970-11eb-0b6a-ebe739db8037
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 66663fcc-0a58-11eb-3568-c1f990c75bf2
if !@isdefined(origin)
	not_defined(:origin)
else
	let
		if origin isa Missing
			still_missing()
		elseif !(origin isa Coordinate)
			keep_working(md"Make sure that `origin` is a `Coordinate`.")
		else
			if origin == Coordinate(0,0)
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ ad1253f8-0a34-11eb-265e-fffda9b6473f
if !@isdefined(make_tuple)
	not_defined(:make_tuple)
else
	let
		result = make_tuple(Coordinate(2,1))
		if result isa Missing
			still_missing()
		elseif !(result isa Tuple)
			keep_working(md"Make sure that you return a `Tuple`, like so: `return (1, 2)`.")
		else
			if result == (2,1)
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ 058e3f84-0a34-11eb-3f87-7118f14e107b
if !@isdefined(trajectory)
	not_defined(:trajectory)
else
	let
		c = Coordinate(8,8)
		t = trajectory(c, 100)
		
		if t isa Missing
			still_missing()
		elseif !(t isa Vector)
			keep_working(md"Make sure that you return a `Vector`.")
		elseif !(all(x -> isa(x, Coordinate), t))
			keep_working(md"Make sure that you return a `Vector` of `Coordinate`s.")
		else
			if length(t) != 100
				almost(md"Make sure that you return `n` elements.")
			elseif 1 < length(Set(t)) < 90
				correct()
			else
				keep_working(md"Are you sure that you chose each step randomly?")
			end
		end
	end
end

# ╔═╡ 4fac0f36-0a59-11eb-03d0-632dc9db063a
if !@isdefined(initialize)
	not_defined(:initialize)
else
	let
		N = 200
		result = initialize(N, 1)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Vector) || length(result) != N
			keep_working(md"Make sure that you return a `Vector` of length `N`.")
		elseif any(e -> !(e isa Agent), result)
			keep_working(md"Make sure that you return a `Vector` of `Agent`s.")
		elseif length(Set(result)) != N
			keep_working(md"Make sure that you create `N` **new** `Agent`s. Do not repeat the same agent multiple times.")
		elseif sum(a -> a.status == S, result) == N-1 && sum(a -> a.status == I, result) == 1
			if 8 <= length(Set(a.position for a in result)) <= 9
				correct()
			else
				keep_working(md"The coordinates are not correctly sampled within the box.")
			end
		else
			keep_working(md"`N-1` agents should be Susceptible, 1 should be Infectious.")
		end
	end
end

# ╔═╡ 8f57abfa-cb0c-4cf0-968d-895ee5db949a
TODO = html"<span style='display: inline; font-size: 2em; color: purple; font-weight: 900;'>TODO</span>"

# ╔═╡ 9ccc9b10-dba6-4325-a80d-47918fc189bf
TODO

# ╔═╡ 601f4f54-0a45-11eb-3d6c-6b9ec75c6d4a
TODO

# ╔═╡ d5cb6b2c-0a66-11eb-1aff-41d0e502d5e5
bigbreak = html"<br><br><br><br>";

# ╔═╡ fcafe15a-0a66-11eb-3ed7-3f8bbb8f5809
bigbreak

# ╔═╡ ed2d616c-0a66-11eb-1839-edf8d15cf82a
bigbreak

# ╔═╡ c2633a8b-374c-40a7-a827-b186d423fee5
bigbreak

# ╔═╡ e84e0944-0a66-11eb-12d3-e12ae10f39a6
bigbreak

# ╔═╡ e0baf75a-0a66-11eb-0562-938b64a473ac
bigbreak

# ╔═╡ Cell order:
# ╟─19fe1ee8-0970-11eb-2a0d-7d25e7d773c6
# ╟─1bba5552-0970-11eb-1b9a-87eeee0ecc36
# ╟─49567f8e-09a2-11eb-34c1-bb5c0b642fe8
# ╟─181e156c-0970-11eb-0b77-49b143cc0fc0
# ╠═1f299cc6-0970-11eb-195b-3f951f92ceeb
# ╟─2848996c-0970-11eb-19eb-c719d797c322
# ╠═2dcb18d0-0970-11eb-048a-c1734c6db842
# ╟─69d12414-0952-11eb-213d-2f9e13e4b418
# ╟─fcafe15a-0a66-11eb-3ed7-3f8bbb8f5809
# ╟─3e54848a-0954-11eb-3948-f9d7f07f5e23
# ╟─3e623454-0954-11eb-03f9-79c873d069a0
# ╠═0ebd35c8-0972-11eb-2e67-698fd2d311d2
# ╟─027a5f48-0a44-11eb-1fbf-a94d02d0b8e3
# ╠═b2f90634-0a68-11eb-1618-0b42f956b5a7
# ╟─66663fcc-0a58-11eb-3568-c1f990c75bf2
# ╟─3e858990-0954-11eb-3d10-d10175d8ca1c
# ╠═189bafac-0972-11eb-1893-094691b2073c
# ╟─ad1253f8-0a34-11eb-265e-fffda9b6473f
# ╟─73ed1384-0a29-11eb-06bd-d3c441b8a5fc
# ╠═96707ef0-0a29-11eb-1a3e-6bcdfb7897eb
# ╠═b0337d24-0a29-11eb-1fab-876a87c0973f
# ╟─9c9f53b2-09ea-11eb-0cda-639764250cee
# ╠═e24d5796-0a68-11eb-23bb-d55d206f3c40
# ╠═ec8e4daa-0a2c-11eb-20e1-c5957e1feba3
# ╟─e144e9d0-0a2d-11eb-016e-0b79eba4b2bb
# ╟─ec576da8-0a2c-11eb-1f7b-43dec5f6e4e7
# ╟─71c358d8-0a2f-11eb-29e1-57ff1915e84a
# ╠═5278e232-0972-11eb-19ff-a1a195127297
# ╟─71c9788c-0aeb-11eb-28d2-8dcc3f6abacd
# ╠═69151ce6-0aeb-11eb-3a53-290ba46add96
# ╟─3eb46664-0954-11eb-31d8-d9c0b74cf62b
# ╠═edf86a0e-0a68-11eb-2ad3-dbf020037019
# ╠═44107808-096c-11eb-013f-7b79a90aaac8
# ╟─87ea0868-0a35-11eb-0ea8-63e27d8eda6e
# ╟─058e3f84-0a34-11eb-3f87-7118f14e107b
# ╠═478309f4-0a31-11eb-08ea-ade1755f53e0
# ╠═51788e8e-0a31-11eb-027e-fd9b0dc716b5
# ╟─3ebd436c-0954-11eb-170d-1d468e2c7a37
# ╠═dcefc6fe-0a3f-11eb-2a96-ddf9c0891873
# ╟─b4d5da4a-09a0-11eb-1949-a5807c11c76c
# ╠═0237ebac-0a69-11eb-2272-35ea4e845d84
# ╠═ad832360-0a40-11eb-2857-e7f0350f3b12
# ╟─b4ed2362-09a0-11eb-0be9-99c91623b28f
# ╠═0665aa3e-0a69-11eb-2b5d-cd718e3c7432
# ╠═903fd22c-a47d-4c74-b6a7-7a71f6c4d0b2
# ╠═1be6f8f0-f8df-46a0-8e57-634d825fc87c
# ╠═79969ac2-ef82-4245-a787-cd04a566bf7b
# ╟─ed2d616c-0a66-11eb-1839-edf8d15cf82a
# ╟─3ed06c80-0954-11eb-3aee-69e4ccdc4f9d
# ╠═1b653338-4406-4313-83a5-ad6ba1b7ec78
# ╠═35537320-0a47-11eb-12b3-931310f18dec
# ╠═cf2f3b98-09a0-11eb-032a-49cc8c15e89c
# ╠═23f252c9-4df8-49e6-a687-05541ad457f1
# ╟─814e888a-0954-11eb-02e5-0964c7410d30
# ╠═0cfae7ba-0a69-11eb-3690-d973d70e47f4
# ╠═0220c8ae-2cea-4c4f-b687-f640d3393d8b
# ╠═1d0f8eb4-0a46-11eb-38e7-63ecbadbfa20
# ╠═622de9c7-76f9-44c0-90ea-bd97e6d2dbdb
# ╠═ae2be3cb-4fc2-41cc-a46c-5d7e2436a0ab
# ╟─4fac0f36-0a59-11eb-03d0-632dc9db063a
# ╠═e0b0880c-0a47-11eb-0db2-f760bbbf9c11
# ╠═b5a88504-0a47-11eb-0eda-f125d419e909
# ╠═87a4cdaa-0a5a-11eb-2a5e-cfaf30e942ca
# ╠═bd9973c8-bcf0-4c49-8245-2d2801a47477
# ╟─49fa8092-0a43-11eb-0ba9-65785ac6a42f
# ╠═1ccc961e-0a69-11eb-392b-915be07ef38d
# ╠═1f96c80a-0a46-11eb-0690-f51c60e57c3f
# ╟─c2633a8b-374c-40a7-a827-b186d423fee5
# ╟─f953e06e-099f-11eb-3549-73f59fed8132
# ╠═e6dd8258-0a4b-11eb-24cb-fd5b3554381b
# ╠═de88b530-0a4b-11eb-05f7-85171594a8e8
# ╟─122461d6-4fbd-4952-b255-eba1109afcc3
# ╟─8029fbe9-32b0-4057-8a18-559b0cb1cb97
# ╟─ffc3672c-604b-4d44-85aa-dd16b5527131
# ╟─fb89dbd3-e6b5-42b7-b09d-ed451e3e4077
# ╟─2965e4dc-0d4a-40f7-93f8-a4696136c031
# ╟─80f39140-0aef-11eb-21f7-b788c5eab5c9
# ╠═17aa8b9f-a850-4f6a-9782-767625963627
# ╟─4c5dd69d-1ef1-434f-bd5c-9c260fb0e819
# ╟─34778744-0a5f-11eb-22b6-abe8b8fc34fd
# ╠═24fe0f1a-0a69-11eb-29fe-5fb6cbf281b8
# ╟─1fc3271e-0a45-11eb-0e8d-0fd355f5846b
# ╠═18552c36-0a4d-11eb-19a0-d7d26897af36
# ╠═4e7fd58a-0a62-11eb-1596-c717e0845bd5
# ╠═778c2490-0a62-11eb-2a6c-e7fab01c6822
# ╟─e964c7f0-0a61-11eb-1782-0b728fab1db0
# ╠═9c006b31-7c64-4741-b4b6-f676dbf40d6e
# ╠═21940771-c6c4-4435-a245-cb955b5b33f1
# ╠═4d83dbd0-0a63-11eb-0bdc-757f0e721221
# ╠═789ee0fe-8f0e-4bfc-b5a7-ca8ae78e22ec
# ╟─8475baf0-0a63-11eb-1207-23f789d00802
# ╟─201a3810-0a45-11eb-0ac9-a90419d0b723
# ╠═9ccc9b10-dba6-4325-a80d-47918fc189bf
# ╠═e5040c9e-0a65-11eb-0f45-270ab8161871
# ╟─f9b9e242-0a53-11eb-0c6a-4d9985ef1687
# ╟─2031246c-0a45-11eb-18d3-573f336044bf
# ╠═a3d5a571-2353-4d64-8721-ff7f2df995d2
# ╠═ff66557c-8014-47a8-9656-060d35d4c8b2
# ╠═65af5a0f-1d46-4a84-9332-439e7672ee7e
# ╠═f4ba77a7-0be0-4b43-80ec-829246acc9a1
# ╠═63dd9478-0a45-11eb-2340-6d3d00f9bb5f
# ╠═269955e4-0a46-11eb-02cc-1946dc918bfa
# ╠═4d4548fe-0a66-11eb-375a-9313dc6c423d
# ╟─20477a78-0a45-11eb-39d7-93918212a8bc
# ╠═601f4f54-0a45-11eb-3d6c-6b9ec75c6d4a
# ╠═b1b1afda-0a66-11eb-2988-752405815f95
# ╟─e84e0944-0a66-11eb-12d3-e12ae10f39a6
# ╟─05c80a0c-09a0-11eb-04dc-f97e306f1603
# ╟─b53d5608-0a41-11eb-2325-016636a22f71
# ╠═1b5e72c6-0a42-11eb-3884-a377c72270c7
# ╟─c704ea4c-0aec-11eb-2f2c-859c954aa520
# ╠═fc1d170a-e175-4544-9ccc-8f0bbae6ccd6
# ╠═e97e39aa-0a5d-11eb-3d5f-f90a0acfe5a2
# ╠═474916f2-bb43-4cae-87d5-1ae43a5358b4
# ╠═19e712f5-93df-47d2-a626-9a1a585ab46d
# ╠═352f67c3-8f63-4705-8c18-20e375add279
# ╠═878c0750-98ce-4395-aed3-449e46a1a1da
# ╠═65751ddb-e127-4239-b821-567a29017bdf
# ╟─b554b654-0a41-11eb-0e0d-e57ff68ced33
# ╠═40c1c1d6-0a69-11eb-3913-59e9b9ec4332
# ╠═144524e9-093b-4302-8537-cdd39ef00183
# ╟─18ac9926-0aed-11eb-034f-e9849b71c9ac
# ╠═d07b71b3-8c6b-4a97-986e-0d964381a638
# ╠═7e03de25-4da2-4ebb-9d09-0b1c0bc6aa36
# ╠═fbe3f295-6e72-4e0c-8166-cf1ba881f691
# ╟─b56ba420-0a41-11eb-266c-719d39580fa9
# ╠═465e918a-0a69-11eb-1b59-01150b4b0f36
# ╠═44b73dc0-abfb-47d7-8583-9849ee5d7267
# ╠═2fab5878-806e-4d6d-92cc-64a3da2fed06
# ╟─a885bf78-0a5c-11eb-2383-9d74c8765847
# ╠═1f172700-0a42-11eb-353b-87c0039788bd
# ╟─b59de26c-0a41-11eb-2c67-b5f3c7780c91
# ╠═faec52a8-0a60-11eb-082a-f5787b09d88c
# ╟─b5b4d834-0a41-11eb-1b18-1bd626d18934
# ╠═a83c96e2-0a5a-11eb-0e58-15b5dda7d2d2
# ╟─05fc5634-09a0-11eb-038e-53d63c3edaf2
# ╠═24c2fb0c-0a42-11eb-1a1a-f1246f3420ff
# ╟─c7649966-0a41-11eb-3a3a-57363cea7b06
# ╠═2635b574-0a42-11eb-1daa-971b2596ce44
# ╟─c77b085e-0a41-11eb-2fcb-534238cd3c49
# ╠═274fe006-0a42-11eb-1869-29193bb84957
# ╟─c792374a-0a41-11eb-1e5b-89d9de2cf1f9
# ╠═d147f7f0-0a66-11eb-2877-2bc6680e396d
# ╟─e0baf75a-0a66-11eb-0562-938b64a473ac
# ╟─0e6b60f6-0970-11eb-0485-636624a0f9d7
# ╟─0a82a274-0970-11eb-20a2-1f590be0e576
# ╟─0aa666dc-0970-11eb-2568-99a6340c5ebd
# ╟─0acaf3b2-0970-11eb-1d98-bf9a718deaee
# ╟─0afab53c-0970-11eb-3e43-834513e4632e
# ╟─0b21c93a-0970-11eb-33b0-550a39ba0843
# ╟─0b470eb6-0970-11eb-182f-7dfb4662f827
# ╟─0b6b27ec-0970-11eb-20c2-89515ee3ab88
# ╟─0b901714-0970-11eb-0b6a-ebe739db8037
# ╟─8f57abfa-cb0c-4cf0-968d-895ee5db949a
# ╟─d5cb6b2c-0a66-11eb-1aff-41d0e502d5e5
