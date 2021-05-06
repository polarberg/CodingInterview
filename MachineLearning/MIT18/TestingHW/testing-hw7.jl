using BenchmarkTools
using Plots
function bernoulli(p::Number)
	rand() < p
end
VERSION
with_terminal() do 
	versioninfo()
end 


@enum InfectionStatus S I R # new type  # susceptible, infectious, recovered

test_status = S
typeof(test_status)
Integer(test_status)


mutable struct Agent
	status::InfectionStatus
	num_infected::Int64
end
methods(Agent)

test_agent = Agent(S,0)
Agent() = Agent(S,0) # outer constuctor 
Agent()

function set_status!(agent::Agent, new_status::InfectionStatus) # modifies argument 
	agent.status = new_status
end

function set_num_infected!(agent::Agent, new_num_infected::Int64)
	agent.num_infected = new_num_infected
end 

test_agent.status == S
function is_susceptible(agent::Agent)
	
	return agent.status == S 
end

function is_infected(agent::Agent)
	
	return agent.status == I
end

function generate_agents(N::Integer) # returns a vector of N freshly created Agent S 
	#all initially susceptible except one, chosen at random, who is infectious	
	ans = [Agent() for i in 1:N]
	rand_pos = rand(1:N)
	set_status!(ans[rand_pos], I)
	return ans
end

rand(1:10)


abstract type AbstractInfection end # immutable struct 

struct InfectionRecovery <: AbstractInfection
	p_infection
	p_recovery
end

function interact!(agent::Agent, source::Agent, infection::InfectionRecovery)
	# agent is S, source is I => source infects agent with infection prob 
	if is_susceptible(agent) && is_infected(source) && bernoulli(infection.p_infection) 
		set_status!(agent, I) # agent becomes infected  
		source.num_infected+=1 # source infected record increases!
	elseif is_infected(agent) && bernoulli(infection.p_recovery) 
		set_status!(agent, R) # set recovered 
	end 
end

let
	agent = Agent(S, 0)
	source = Agent(I, 0)
	infection = InfectionRecovery(0.9, 0.5)
	
	interact!(agent, source, infection)
	
	(agent=agent, source=source)
end

function step!(agents::Vector{Agent}, infection::InfectionRecovery)
	# Choose two random agents: an agent and a source.
	n = size(agents,1) 
	chosen_Agent = agents[rand(1:n)]
	chosen_Source = agents[rand(1:n)] # how do u not choose the same person 

	interact!(chosen_Agent, chosen_Source, infection) # Apply interact!(agent, source, infection).
	
	return agents # Return agents.
end

function sweep!(agents::Vector{Agent}, infection::AbstractInfection) # runs step!, N times (num of agents ) 
	for i in 1:size(agents,1) 
		step!(agents, infection) 
	end 
	# a sweep is thus the unit of time in our Monte Carlo simulation
end

let 
	testAgents = generate_agents(5)
		n = size(testAgents,1)
		infection = InfectionRecovery(0.9, 0.5)
	A₁=testAgents[rand(1:n)]
	A₂=testAgents[rand(1:n)]
	#interact!(A₂,A₁,infection)
	sweep!(testAgents,infection)
	testAgents
#= 	numInfected = 0 # for testing sim recording statuses 
	for i in 1:n
		if is_infected(testAgents[i]) 
			numInfected+=1 
		end 
	end 
	numInfected =#
end 

function simulation(N::Integer, T::Integer, infection::AbstractInfection)
	# Gen N agents 
	Population = generate_agents(N)
	S_counts, I_counts, R_counts = [], [], [] # store # of agents with each status at each step 
	
	# run sweep! T times 
	for i in 1:T 
		sweep!(Population, infection)
		# record statuses at EACH step 
		tmp_counts = [0,0,0] # (S,I,R) 
		for i in 1:N 
			if is_susceptible(Population[i])
				tmp_counts[1] += 1 
			elseif is_infected(Population[i]) 
				tmp_counts[2] += 1 
			else # is_recovered() 
				tmp_counts[3] += 1 
			end 
		end 
		push!(S_counts, tmp_counts[1]); push!(I_counts, tmp_counts[2]); push!(R_counts, tmp_counts[3]); 
	end  	

	return (S=S_counts, I=I_counts, R=R_counts)	
end
simulation(3, 20, InfectionRecovery(0.9, 0.2))

let
	
	N = 100
	T = 1000
	sim = simulation(N, T, InfectionRecovery(0.02, 0.002))
	
	result = plot(1:T, sim.S, ylim=(0, N), label="Susceptible")
	plot!(result, 1:T, sim.I, ylim=(0, N), label="Infectious")
	plot!(result, 1:T, sim.R, ylim=(0, N), label="Recovered")
end

function repeat_simulations(N, T, infection, num_simulations)
	N = 100
	T = 1000
	
	map(1:num_simulations) do _
		simulation(N, T, infection)
	end
end
simulations = repeat_simulations(100, 1000, InfectionRecovery(0.02, 0.002), 20)
(simulations[1].S + simulations[1].I + simulations[1].R) .÷ 100
plot(simulations[1].I, lw=3)
(simulations[1].I + simulations[2].I) .÷ 2
length(simulations)

let
	p = plot()
	
	for sim in simulations
		plot!(p, 1:1000, sim.I, alpha=.5, label=nothing)
	end
	
	n = length(first(simulations).I) # number of timesteps 
	mean_Num_of_I = zeros(n)
	
#= 	for j in 1:n # for each time step 
		for i in 1:length(simulations) # for each simulation
			mean_Num_of_I[j] += simulations[i].I[j] # jth elem 
		end 
		mean_Num_of_I[j] ÷= size(simulations,1)
	end  =#

	for i in 1:length(simulations) # add up all simulations into one 
		mean_Num_of_I += simulations[i].I 
	end 
	mean_Num_of_I .÷= 20
	plot!(mean_Num_of_I, lw=3)
	p
end

let 
	T = first(simulations).S
end 
function sir_mean_plot(simulations::Vector{<:NamedTuple})
	# you might need T for this function, here's a trick to get it:
	T = length(first(simulations).S)
	
	return missing
end


