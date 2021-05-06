using Plots, BenchmarkTools, Statistics

function counts(data::Vector)
	counts = Dict{Int, Int}()
	for elem in data 
		if haskey(counts, elem)
            counts[elem] += 1
        else 
            counts[elem] = 1
		end 
	end 
	return counts
end

test_data = [1, 0, 1, 0, 1000, 1, 1, 1000]
test_counts = counts(test_data)
ks = collect(keys(test_counts))
vs = collect(values(test_counts))

perm = sortperm(ks)
ks[perm]
vs[sortperm(vs)]


function counts2(data::Vector)
	cnts = counts(data)
    # Extract vectors ks of keys and vs of values using the keys() and values() functions 
    ks = collect(keys(cnts)) # collect: converts the results into a vector 
    vs = collect(values(cnts))

    perm = sortperm(ks) # which order to take the keys to give a sorted version 

	return ks[perm],vs[perm]
end
result = counts2([51,-52,-52,53,51])
sum(result[2])
for i in 1:size(result[1],1) # for each keys, replace freq with proportion 
    vec[2][i] = vec[2][i] / total 
end 
result[1][1] , result[2][1] / 5

function probability_distribution(data::Vector)
    prob = [] 
	vec = counts2(data) # vector of tuples of keys and vals, sorted in order of key 
    total = sum(vec[2]) # sum of all frequencies 

    for i in 1:size(vec[1],1) # for each keys, replace freq with proportion 
        tmp_prob = vec[2][i] / total 
        push!(prob, tmp_prob)
    end 
	return vec[1] , Float64.(prob)
end

function prob2(data::Vector)
    vec = counts2(data) # vector of tuples of keys and vals, sorted in order of key 
    total = sum(vec[2]) # sum of all frequencies
    return vec[1] , [vec[2][i] / total for i in 1:size(vec[1],1)]
end
@btime probability_distribution([51,-52,-52,53,51])
@btime prob2([51,-52,-52,53,51])
RRRRRAANNOM = rand(1:1:100,10000)
@benchmark probability_distribution(RRRRRAANNOM)
@benchmark prob2(RRRRRAANNOM)

function bernoulli(p::Real)
	
	return rand() < p
end

function geometric(p::Real)
    if p==0 
		return 0 
	elseif p==1
		return 1 
	end 
	
	recovery_time = 0 
	recovered = false 
	while(!recovered)
		recovery_time+=1
		recovered = bernoulli(p)
	end 
	
	return recovery_time
end
bernoulli(0)
bernoulli(1)
geometric(.9)
geometric(0.2)

samples = [geometric(0.2) for _ in 1:256]


function experiment(p::Real, N::Integer) # runs geometric N times and colelcts results into vector
	
	return [ geometric(p) for i=1:N]
end

small_experiment = experiment(0.5, 20)
mean(small_experiment)
large_experiment = experiment(0.25, 10000)
let
	xs, ps = probability_distribution(large_experiment)
		
	bar(xs, ps, alpha=0.5, leg=false)	
end

m=mean(large_experiment)

# add Mean recovery time to plot 
let
	xs, ps = probability_distribution(large_experiment)
		
	bar(xs, ps, alpha=0.5, leg=false)	
	vline!([m],ls=:dash)
end

let # log graph
	xs, ps = probability_distribution(large_experiment)
		
	bar(xs, ps, yscale=:log10, alpha=0.5, leg=false)	
	vline!([m],ls=:dash)	
end

function PlotExp(p::Real, N::Integer)
    small_experiment = experiment(p,N)
    xs, ps = probability_distribution(small_experiment)
		
	bar(xs, ps, yscale=:log10, alpha=0.5, leg=false)	
	vline!([m],ls=:dash)
end 

PlotExp(0.25,100000)

function meanExp(p::Real, N=10000) 
	
	return mean(experiment(p,N))
end 
prob_P_vs_tP=0.01
bar(0:prob_P_vs_tP:1, [meanExp(i) for i in 0:prob_P_vs_tP:1])


sum(i for i in 1:10)
function cumulative_sum(xs::Vector)
	total=0
	ans = []
	for i in 1:size(xs)
		total += xs[i] 
		push!(ans, total )
	end
	return ans
end

let 
    xs =[1, 3, 5, 7, 9]
    total=0
	ans = []
	for i in 1:size(xs,1)
		total += xs[i] 
		push!(ans, total )
	end
    total
	ans
end

function geometric_bin(u::Real, p::Real) #(r,p) r=1-p
	
	return -log(cumulative_sum())
end