using BenchmarkTools
using Plots
using Statistics

begin #calculating S.D. 
	v = rand(100)
	m = sum(v) / length(v)  # mean
	σ² = sum( (v .- m) .^ 2 ) / (length(v) - 1)
	σ = sqrt(σ²)
end 
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

function step!(agents::Vector{Agent}, infection::AbstractInfection) # AbstractInfection more general than InfectionRecovery
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

function repeat_simulations(N::Int64=100, T::Int64=1000, infection::AbstractInfection=InfectionRecovery(0.02, 0.002), num_simulations::Int64=20)
	map(1:num_simulations) do _
		simulation(N, T, infection)
	end
end

function pri(y::Int64=1)
	print(y)
end
pri(2)

simulations = repeat_simulations(100, 1000, InfectionRecovery(0.02, 0.002), 20)
(simulations[1].S + simulations[1].I + simulations[1].R) .÷ 100
plot(simulations[1].I, lw=3)
(simulations[1].I + simulations[2].I) .÷ 2
length(simulations)
zeros(Int64, length(first(simulations).I)) + simulations[1].I
@btime let
	p = plot()
	
	for sim in simulations
		plot!(p, 1:1000, sim.I, alpha=.5, label=nothing)
	end
	
	Num_TimeSteps = length(first(simulations).I) # number of timesteps 
	Num_Sims = length(simulations)
	mean_Num_of_I = zeros(Int64,Num_TimeSteps)

	for i in 1:Num_Sims # add up all simulations into one 
		mean_Num_of_I += simulations[i].I 
	end 
	mean_Num_of_I .÷= Num_Sims
	plot!(mean_Num_of_I, lw=2, linecolor="magenta")
	p
end

zeros(Int64,1000,3)[:,1] + simulations[1].S
function sir_mean_plot(simulations::Vector{<:NamedTuple}) # returns a plot of the means of S I R,  and  as a function of time on a single graph.
	# you might need T for this function, here's a trick to get it:
	Num_TimeSteps = length(first(simulations).I) # number of timesteps 
	mean_SIR = zeros(Num_TimeSteps,3) # array to plot S I R 
	Num_Sims = length(simulations) # num of sims 
	
	p = plot() 

	for i in 1:Num_Sims # add up all simulations into one 
		mean_SIR[:,1] += simulations[i].S 
		mean_SIR[:,2] += simulations[i].I 
		mean_SIR[:,3] += simulations[i].R 
	end 

	mean_SIR ./= Num_Sims

	plot!(mean_SIR[:,1], label="Susceptible")
	plot!(mean_SIR[:,2], label="Infectious")
	plot!(mean_SIR[:,3], label="Recovered")
	return p
end
@btime sir_mean_plot(simulations)
simulations[1].S[1]

function sir_mean_error_plot(simulations::Vector{<:NamedTuple}) # does the same as sir_mean_plot, which also computes the standard deviation  of S, I, R at each step.
	# you might need T for this function, here's a trick to get it:
	Num_TimeSteps = length(first(simulations).I) # number of timesteps 
	Num_Sims = length(simulations) # num of sims 
	
	mean_SIR = zeros(Num_TimeSteps,3) # array to plot mean S I R  # (row,S or I or R)
	STD_SIR = zeros(Num_TimeSteps,3) # vectors of std at each timestep 
	
	tmp_Mean_V = zeros(Num_Sims,3)

	mean_error_plot = plot(dpi=10000) 

	for t in 1:Num_TimeSteps
		for s in 1:Num_Sims # copies 't'th element of SIR into tmp_Mean_V
			tmp_Mean_V[s,1] = simulations[s].S[t] 
			tmp_Mean_V[s,2] = simulations[s].I[t] 
			tmp_Mean_V[s,3] = simulations[s].R[t] 
		end  
		mean_SIR[t,1] = mean(tmp_Mean_V[:,1])
		mean_SIR[t,2] = mean(tmp_Mean_V[:,2])
		mean_SIR[t,3] = mean(tmp_Mean_V[:,3])

		STD_SIR[t,1] = std(tmp_Mean_V[:,1])
		STD_SIR[t,2] = std(tmp_Mean_V[:,2])
		STD_SIR[t,3] = std(tmp_Mean_V[:,3])
	end 

	plot!(mean_SIR[:,1], ribbon=STD_SIR[:,1], lw=1, label="Susceptible")
	plot!(mean_SIR[:,2], ribbon=STD_SIR[:,2], lw=1, label="Infectious")
	plot!(mean_SIR[:,3], ribbon=STD_SIR[:,3], lw=1, label="Recovered")

	return mean_error_plot
end
sir_mean_error_plot(simulations)

histogram(simulations[1].I)




# ReInfection - New type of infection 
struct Reinfection <: AbstractInfection 
	p_infection
	p_recovery # prob to become susceptible again 
end

function interact!(agent::Agent, source::Agent, infection::Reinfection)
		# agent is S, source is I => source infects agent with infection prob 
		if is_susceptible(agent) && is_infected(source) && bernoulli(infection.p_infection) 
			set_status!(agent, I) # agent becomes infected  
			source.num_infected+=1 # source infected record increases!
		elseif is_infected(agent) && bernoulli(infection.p_recovery) 
			set_status!(agent, S) # set back to susceptible***  
		end 
end

simulation(3,20,Reinfection(0.1,0.1))
repeat_simulations(100,1000,Reinfection(0.1,0.1),20)
sir_mean_plot(repeat_simulations(100,1000,Reinfection(0.1,0.001),20))
cols = 9
parry = zeros(cols,100)
for row in 1:cols
	parry[row,:] .= row 
end 

tmpavgvec = zeros(100)
for i in 1:cols
	tmpavgvec += parry[i,:]
end 
tmpavgvec
tmpavgvec ./= cols
tmpavgvec += parry[1,:]
parry[1,:] .= 1