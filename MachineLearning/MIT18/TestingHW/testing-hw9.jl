using Base: Int8
using Plots: push!
using Plots, BenchmarkTools

struct Coordinate 
    x::Int
    y::Int    
end
origin = Coordinate(0,0)


"""
...
# Arguments
- `x::Int`: *x coordinate*
- `y::Int`: *y coordinate*

# Examples
```jldoctest
julia> make_tuple(Coordinate(1,0))
(1, 0)
```

```julia 
function make_tuple(c::Coordinate)
    
    return (c.x,c.y)
end
```
...
"""
function make_tuple(c::Coordinate)
    
    return (c.x,c.y)
end
make_tuple(Coordinate(1,0))


function Base.:+(a::Coordinate, b::Coordinate)
    
    return Coordinate(a.x + b.x, a.y + b.y)
end
let # testing 
    Coordinate(3,4) + Coordinate(10,10) # should be (3+10,4+10) = (13,14)
    +(Coordinate(3,4), Coordinate(10,10)) # infix notation
end 

"In our model, agents will be able to walk in 4 directions: 
\n - **up, down, left and right**
\nWe can define these directions as Coordinate s.\n"
possible_moves = [
	Coordinate( 1, 0), 
	Coordinate( 0, 1), 
	Coordinate(-1, 0), 
	Coordinate( 0,-1),
]
rand(possible_moves,4)
+(Coordinate(4,5), rand(possible_moves)) # infix notation


"""
...
```jldoctest
trajectory(w::Coordinate, n::Int)
```
Calculates a trajectory of a Wanderer, *w*, when performing *n* steps 
\n(the sequence of positions that the walker finds itself in.)
# Arguments
- `w::Coordinate`: *Wanderer*
- `n::Int`: *number of steps*

👉 Write a function `trajectory` that calculates a trajectory of a `Wanderer` `w` when performing `n` steps., i.e. the sequence of positions that the walker finds itself in.

Possible steps:
- Use `rand(possible_moves, n)` to generate a vector of `n` random moves. Each possible move will be equally likely.
- To compute the trajectory you can use either of the following two approaches:
  1. 🆒 Use the function `accumulate` (see the live docs for `accumulate`). Use `+` as the function passed to `accumulate` and the `w` as the starting value (`init` keyword argument). 
  1. Use a `for` loop calling `+`. 
...
"""
function trajectory(w::Coordinate, n::Int)	
    rand_moves = rand(possible_moves, n) # gen vec of n random moves, each move equally likely 

    # computing trajectory
	return accumulate(+, rand_moves; init=w)
end
test_trajectory = trajectory(Coordinate(4,4),1) 

function plot_trajectory!(p::Plots.Plot, trajectory::Vector; kwargs...)
	plot!(p, make_tuple.(trajectory); 
		label=nothing, 
		linewidth=2, 
		linealpha=LinRange(1.0, 0.2, length(trajectory)),
		kwargs...)
end
try
	p = plot(ratio=1, size=(650,200))
	plot_trajectory!(p, test_trajectory; color="black", showaxis=false, axis=nothing, linewidth=4)
	p
catch
end
let
	long_trajectory = trajectory(Coordinate(4,4), 1000)

	p = plot(ratio=1)
	plot_trajectory!(p, long_trajectory)
	p
end

#Plot 10 trajectories of length 1000 on a single figure
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

    """ Boundary Conditions """

"""
Collision Boundary

# Arguments
- `c::Coordinate`: *position*
- `L::Int`: *size*

# Return 
- new Coordinate that lies inside the box `[-L,L] times [-L,L]`
- but is closest to `c`
"""
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
collide_boundary(Coordinate(12,4), 10) # ans: Coordinate(10,4)
 
"""
## Exercise 1.6
👉  3-argument method  of `trajectory` where the third argument is a size. 
The trajectory returned should be within the boundary (use `collide_boundary` from above). 
You can still use `accumulate` with an anonymous function that makes a move 
and then reflects the resulting coordinate, or use a for loop.
# Arguments
- `w::Coordinate`: *Wanderer*
- `n::Int`: *number of steps*
- `L::Number`: *boundary*

# Implementation
```julia 
function trajectory(c::Coordinate, n::Int, L::Number)
    # gen vec of n random moves, each move equally likely 
    rand_moves = rand(possible_moves, n)

    # computing trajectory
	return accumulate( (x,y) -> collide_boundary(+(x, y), L) , rand_moves; init=c)
end
```
...
"""
function trajectory(c::Coordinate, n::Int, L::Number)
    rand_moves = rand(possible_moves, n) # gen vec of n random moves, each move equally likely 

    # computing trajectory
	return accumulate( (x,y) -> collide_boundary(+(x, y), L) , rand_moves; init=c)
end
trajectory(Coordinate(0,0),1,10)

let
    ytyj = (x,y) -> collide_boundary(+(x, y), 10)
    ytyj(Coordinate(10,10), rand(possible_moves))
end 

let 
    # Create a new plot with aspect ratio 1:1
    p = plot(ratio=1)

    starting_point = (0,0) # all starting at the origin
    num_steps = 1000
    num_plots = 4
    bounds = 20

    for i in 1:num_plots
        plot_trajectory!(p, trajectory(Coordinate(starting_point[1],starting_point[2]), num_steps, bounds) )  # plot one trajectory
    end 
    
    p
end

abstract type AbstractAgent end 

@enum InfectionStatus S I R
begin 
    mutable struct Agent <: AbstractAgent
        position::Coordinate
        status::InfectionStatus
    end

    Agent() = Agent(Coordinate(0,0), S)
    Agent(x::Int,y::Int, Status::InfectionStatus) = Agent(Coordinate(x,y), Status)
    Agent(Status::InfectionStatus) = Agent(Coordinate(0,0), Status)
end 

Agent() # testing constructor
Agent(0,0,S)
Agent(I)
"
```julia 
initialize(Number of Agents::Number, L::Number)
```
# Input:
- `N::Number`: number of agents 
- `L::Number`: 2L is side length of the square box where the agents live 

# Return: 
- Vector of *N* randomly generated Agent *S*
- Their coordinates are randomly sampled in the ``[-L,L] × [-L,L]`` box,
- the agents are all susceptible, except one, chosen at random, which is infectious.
"
function initialize(N::Number, L::Number)
	# gen vector of N agents coordinates within boundary,
        # initialized to susceptible
    population = [Agent(Coordinate(rand(-L:L),rand(-L:L)), S) for i in 1:N] 

    rand(population).status = I # one agent chosen at random is infectious
	return population
end
initialize(3, 10)

let # testing
    L=10 
    Agent(Coordinate(rand(-L:L),rand(-L:L)), S)
end


# Color based on infection status
color(s::InfectionStatus) = 
if s == S
	"blue"
elseif s == I
	"red"
else
	"green"
end

Base.:position(a::Agent) = a.position 
color(a::Agent) = color(a.status) 
#status(a::Agent) = a.status # I added
status(a::AbstractAgent) = a.status # I added


position.(initialize(3, 10))
status.(initialize(3, 10))
length(initialize(3, 10))

" 
...\n
Plot a point for each agent at its location, coloured according to its status.
# Arguments
- `agents::Vector`: Collection of agents 
- `L`: Box size 'L' 
\nYou can use the keyword argument `c=color.(agents)` inside your call to the plotting function make the point colors correspond to the infection statuses. 
"
function visualize(agents::Vector, L)

    #positions = position.(agents).x,position.(agents).y
    positions = make_tuple.(position.(agents))
    c = color.(agents)
    plot(positions, color = c, group=status.(agents), 
            seriestype = :scatter, title = "Initialized SIR", ratio=1,
            lims=[-L,L]) # , background_color = "magenta"
end

let # test
	N = 20
	L = 10
	visualize(initialize(N, L), L) # uncomment this line!
end


md"""

### Exercise 3: Spatial epidemic model -- Dynamics

Last week we wrote a function `interact!` that takes two agents, `agent` and `source`, and an infection of type `InfectionRecovery`, which models the interaction between two agent, and possibly modifies `agent` with a new status.

This week, we define a new infection type, `CollisionInfectionRecovery`, and a new method that is the same as last week, except it **only infects `agent` if `agents.position==source.position`**.
"""	

abstract type AbstractInfection end 

struct CollisionInfectionRecovery <: AbstractInfection 
    p_infection::Float64
    p_recovery::Float64 
end

#old functions 
function bernoulli(p::Number)
	rand() < p
end
function set_status!(agent::Agent, new_status::InfectionStatus) # modifies argument 
	# your code here
	agent.status = new_status
end
function is_susceptible(agent::Agent)
	
	return agent.status == S 
end
function is_infected(agent::Agent)
	
	return agent.status == I
end

function is_susceptible(agent::AbstractAgent)
	
	return agent.status == S 
end
function is_infected(agent::AbstractAgent)
	
	return agent.status == I
end
function set_status!(agent::AbstractAgent, new_status::InfectionStatus) # modifies argument 
	# your code here
	agent.status = new_status
end
is_susceptible(SocialAgent())
"
Write a function `interact!` that takes two `Agent`s and a `CollisionInfectionRecovery`, and:

    - If the agents are at the same spot, 
        - causes a susceptible agent to communicate the desease 
            from an infectious one with the correct probability.
    - if the first agent is infectious, it recovers with some probability
"
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
let #testing
    as, ai = Agent(),Agent(I)
    interact!(as, ai, CollisionInfectionRecovery(0.5,0.01))
    as, ai
end 



"""
#### Exercise 3.1
Your turn!

👉 Write a function `step!` that takes a vector of `Agent`s, 
    a box size `L` and an `infection`. 
    This that does one step of the dynamics on a vector of agents. 

- Choose an Agent `source` at random.

- Move the `source` one step, and use `collide_boundary` 
    to ensure that our agent stays within the box.

- For all _other_ agents, call `interact!(other_agent, source, infection)`.

- return the array `agents` again.
"""
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
let 
    L=1
    testPop = initialize(12,L)
    plot_before = visualize(testPop, L)
    for i in 1:length(testPop)*1000
        step!(testPop,L,CollisionInfectionRecovery(0.5, 0.00001))
    end
    plot_after = visualize(testPop, L)
    plot(plot_before, plot_after)
    testPop 
end
    
function sweep!(agents::Vector, L::Number, infection::AbstractInfection)
	for i in 1:size(agents,1)
		step!(agents, L, infection) 
	end 
end

let
    k_sweeps = 1000
    pandemic = CollisionInfectionRecovery(0.5, 0.00001)
	N = 100
	L = 5
	
    agents = initialize(N,L) # initialize vector 

	plot_before = visualize(agents, L)
    
    # run `k_sweeps` k_sweeps
    for i in 1:(k_sweeps)
        sweep!(agents, L, pandemic) # runs step!, n times each sweep 
    end 
    plot_after = visualize(agents, L)
	
	plot(plot_before, plot_after)
end

"count ***current*** numbers of SIR"
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
let 
    agents = initialize(10,1)
    count_SIR(agents)
    m = count_SIR(agents)
    for i in 1:10-1
        m = vcat(m,count_SIR(agents))
    end 
    m
    plot(m,color =[color(S) color(I) color(R)])
end


let 
    k_sweep_max = 10000
    N = 50
	L = 1
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

let
    N = 50
    L = 40
    pandemic = CollisionInfectionRecovery(0.5, 0.00001)
    
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


function SIR_plot_adjust_params(N::Int=50, L::Int=40, 
                                    pandemic::AbstractInfection=CollisionInfectionRecovery(0.5,0.001), 
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
pᵢ, pᵣ = 0.1, 0.001
testing_Outbreak = CollisionInfectionRecovery(pᵢ, pᵣ)
SIR_plot_adjust_params(100,20,testing_Outbreak, 1000)








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
SocialAgent(Coordinate(0,0), S , 0,1)

begin
    Base.:position(a::SocialAgent) = a.position
    color(a::SocialAgent) = color(a.status)
    social_score(a::SocialAgent) = a.social_score
    num_infected(a::SocialAgent) = a.num_infected
end
color(SocialAgent(Coordinate(0,0), S , 0,1))
social_score(SocialAgent(Coordinate(0,0), S , 0,1))
num_infected(SocialAgent(Coordinate(0,0), S , 65,1))
" 
creates N (Social)agents  within a 2L x 2L box, with `social_score`s chosen from 
    10 equally-spaced between 0.1 and 0.5. (see LinRange)
# Arguments
- `N::Int`: *Agents*
- `L::Int`: *2L × 2L grid*
"
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

testing_SA = initialize_social(10, 1)
for i in 1:10
    step!(testing_SA,1,CollisionInfectionRecovery(0.5,0.01))
end
testing_SA
visualize(testing_SA, 1)
let
    L=1
    positions = make_tuple.(position.(testing_SA))
    c = color.(testing_SA)
    plot(positions, color = c, group=status.(testing_SA), 
            seriestype = :scatter, title = "Initialized SIR", ratio=1,
            lims=[-L,L]) # , background_color = "magenta"
end
initialize(10,10)
social_score.(initialize_social(10,10))


step!(testing_SA,10,CollisionInfectionRecovery(0.5,0.01))
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


let
	N = 50
	L = 40
	N_sweeps = 100
    pandemic = CollisionInfectionRecovery(0.03, 0.001)

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

md"""
#### Exercise 4.4
👉 Make a scatter plot showing each agent's `social_score` on one axis, and the `num_infected` from the simulation in the other axis. Run this simulation several times and comment on the results.
"""
let 
    N = 50
	L = 40
	N_sweeps = 10000
    pandemic = CollisionInfectionRecovery(0.03, 0.001)

    social_agents = initialize_social(N, L)

    # 1. Step! a lot
	for s in 1:N_sweeps
		sweep!(social_agents, L, pandemic)
    end      
    social_agents
    social_scores_Vec, num_infected_Vec = social_score.(social_agents), num_infected.(social_agents) #x-axis 

    # = # y-axis 
    scatter(social_scores_Vec, num_infected_Vec)
end

scatter([1,2,3],[1,0,3])


for i in 0:1, j in 0:1, z in 0:1
    println(i, j,z )
end 

3<<1
bitstring((3 << 1) + 1)
g=[0,1]
push!(g, g[2]<<1 +1)
push!(g, g[3]<<1 + 1)


push!(g, g[4] - 1)
push!(g, g[5]<<1 + 1)
push!(g, g[6] - 1)

bitstring.(g)
let 
    ans = [
        "000"
        "001"
        "011"
        "111"
        "110"
        "100"
        "101"        
        "100"
        "010"        
    ]
    Int(ans[1])
end
Int("000")
2^16
1<<16
ajifoej = zeros(5)
function grayCode(n::Int)
    count = (1 << n) 
    vec = zeros(Int8, count)
    for i in 1:count-1
        vec[i+1] = i ⊻ (i >> 1)
    end 
    return vec 
end 

bitstring.(grayCode(3))

(2 ⊻ (2 >> 1))
'A' > 'B' 