using Plots

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
...
"""
function make_tuple(c::Coordinate)
    
    return (c.x,c.y)
end
make_tuple(Coordinate(1,0))


function Base.:+(a::Coordinate, b::Coordinate)
    
    return Coordinate(a.x + b.x, a.y + b.y)
end
Coordinate(3,4) + Coordinate(10,10) # should be (3+10,4+10) = (13,14)
+(Coordinate(3,4), Coordinate(10,10)) # infix notation 
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
test_trajectory = trajectory(Coordinate(4,4), 30) 


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
"""
function trajectory(c::Coordinate, n::Int, L::Number)
    rand_moves = rand(possible_moves, n) # gen vec of n random moves, each move equally likely 

    # computing trajectory
	return accumulate( (x,y) -> collide_boundary(+(x, y), L) , rand_moves; init=c)
end
trajectory(Coordinate(0,0),10,10)

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


@enum InfectionStatus S I R
struct Agent
    position::Coordinate
    status::InfectionStatus
end

"
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
    population = [Agent(Coordinate(rand(-L:L),rand(-L:L)), s) for i in 1:N] 

    rand(population).status 
	return population
end
rand(-L:L)

