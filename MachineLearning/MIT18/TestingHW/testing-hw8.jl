using Plots, Symbolics, ForwardDiff, BenchmarkTools

function finite_difference_slope(f::Function, a, h=1e-3)
	
	return (f(a+h) - f(a)) / h
end
finite_difference_slope(sqrt, 4.0, 5.0)

function tangent_line(f, a, h) # returns function 
	# y - y₁ = m(x - x₁)
	return  x -> finite_difference_slope(f,a,h)*(x-a) + f(a)
end
 
# this is our test function
wavy(x) = .1x^3 - 1.6x^2 + 7x - 3;

let
    zeroten = 0:10
    a_finite_diff = 2
    log_h = 3.235936569296281e-5
    h_finite_diff = 10.0^log_h
	p = plot(zeroten, wavy, label="f(x)")
	scatter!(p, [a_finite_diff], [wavy(a_finite_diff)], label="a", color="red")
	vline!(p, [a_finite_diff], label=nothing, color="red", linestyle=:dash)
	scatter!(p, [a_finite_diff+h_finite_diff], [wavy(a_finite_diff+h_finite_diff)], label="a + h", color="green")
	
	try
		result = tangent_line(wavy, a_finite_diff, h_finite_diff)
		
		plot!(p, zeroten, result, label="tangent", color="purple")
	catch
	end
	
	plot!(p, xlim=(0,10), ylim=(-2, 8))
end #|> as_svg




function euler_integrate_step(fprime::Function, fa::Number, a::Number, h::Number)
    # f(a+h) ≊ hf′(a) + f(a)     

    return h*fprime(a+h) + fa 
end

function euler_integrate(fprime::Function, fa::Number, 
    T::AbstractRange)

    a0 = T[1]
    h = step(T)

    ans = [euler_integrate_step(fprime,fa,a0,h)]
    for i in 1:length(T)-1
        push!(ans, euler_integrate_step(fprime,ans[i],T[i+1],h))# uses return as input for next 
    end 

    return ans
end
euler_test = let 
    fprime(x) = 3x^2
    r = 0:0.1:10
    euler_integrate(fprime,0,r)
end

### SIR MODEL 
function euler_SIR_step(β, γ, sir_0::Vector, h::Number) # β=p_infection ,γ=p_recovery
	s, i, r = sir_0
	
	Δi = β * s * i
	Δr = γ * i
	return [
		s - h*Δi,
		i + h*(Δi - Δr),
		r + h*Δr,
	]
end
function euler_SIR(β, γ, sir_0::Vector, T::AbstractRange)
	# T is a range, you get the step size and number of steps like so:
	h = step(T)
	
	num_steps = length(T)
	
    vec_of_vecs = [euler_SIR_step(β, γ, sir_0, h)] 
	for i in 1:num_steps-1
        push!(vec_of_vecs, euler_SIR_step(β, γ, vec_of_vecs[i], h))
    end 
	
	return vec_of_vecs
end
sir_T = 0 : 0.1 : 60.0
sir_results = euler_SIR(0.3, 0.15, 
	[0.99, 0.01, 0.00], 
	sir_T)
function plot_sir!(p, T, results; label="", kwargs...)
        s = getindex.(results, [1])
        i = getindex.(results, [2])
        r = getindex.(results, [3])
        
        plot!(p, T, s; color=1, label=label*" S", lw=3, kwargs...)
        plot!(p, T, i; color=2, label=label*" I", lw=3, kwargs...)
        plot!(p, T, r; color=3, label=label*" R", lw=3, kwargs...)
        
        p
end    
plot_sir!(plot(), sir_T, sir_results)
plot(-10:0.1:10,x->1/(1+exp(-x)))


function ∂x(f::Function, a, b)
	# xpart = x -> 2 * f(sqrt(x),0); return xpart(a)
    # using ForwardDiff
    return ForwardDiff.derivative(x->f(x,b), a)
end
∂x(
	(x, y) -> 7x^2 + y, 
	3, 7
)
∂x(
	(x, y) -> 7x^2, 
	3, 7
)

function ∂y(f::Function, a, b)
    #ypart = y -> 2 * f(0,sqrt(y)); return ypart(b)
    return ForwardDiff.derivative(y->f(a,y), b)
end
∂y(
	(x, y) -> 7x^2 + y, 
	3, 7
)


function gradient(f::Function, a, b)
	
	return [ ∂x(f,a,b) , ∂y(f,a,b) ]
end
gradient(
	(x, y) -> 7x^2 + y, 
	3, 7
)


function gradient_descent_1d_step(f, x0; η=0.01) 
	# η · f′(x₀) 
	return x0 - η * finite_difference_slope(f, x0) 
	
	#want to go in opposite direction hence the (-)
end
let
	f = x -> x^2
	# the minimum is at 0, so we should take a small step to the left
	
	gradient_descent_1d_step(f, 5)
end
function gradient_descent_1d(f, x0; η=0.01, N_steps=1000)
	# repeatedly applies previous function N_steps times 
    # returns final ans 

	ans = [gradient_descent_1d_step(f, x0, η = η)]
    for i in 1:N_steps
		next_step = gradient_descent_1d_step(f, ans[i], η = η)
		if(round(next_step, digits=4) == round(ans[i], digits=4))
			return next_step
			# return ans
		else 
        	push!(ans, next_step)
		end
    end 
	return ans[end]
end

let
	f = x -> (x - 5)^2 - 3
	# minimum should be at x = 5
	gradient_descent_1d(f, 0.0)
end
let
	result = gradient_descent_1d(10) do x
		(x - 5pi) ^ 2 + 10
	end
	error = abs(result - 5pi)
end 

    "gradient: direction at point (a,b) where function increases the fastest
    \nnote: grad is a vector 
    \nwe take a small step in the opposite direction
	\nNote2: x0,y0 can be vectors of vectors, not just vector of numbers"
function gradient_descent_2d_step(f, x0, y0; η=0.01) 
	g = η * gradient(f,x0, y0) # 2d vector [∂x,∂y]
	
	return [x0 - g[1], y0 - g[2]]
end
################
[3, 3, 3] - [1,2,3]
[3, 3, 3] + [[1,2,3],[1,2,3]]

himmelbau(x, y) = (x^2 + y - 11)^2 + (x + y^2 - 7)^2
let 
    @variables z, η
    zzzz = x -> ForwardDiff.derivative(a->himmelbau(a,0), x)
    expand(zzzz(z))
end 
# 2*2x(x^2 + 0 - 11) + 2(x - 7)
gradient_descent_2d_step(himmelbau, 0, 0)
round.([3.0,2.0],digits=1) == round.([3.03882,2.029529],digits=1)

"repeatedly applies gradient_descent_2d_step(f, x0, y0; η=0.01), N_steps times 
\nreturns final ans 
\nToDo: Reimplement so that I rewrite the array"
function gradient_descent_2d(f, x0, y0; η=0.01,digits_to_Round = 4)
    N_steps = 10000

    ans = [gradient_descent_2d_step(f, x0, y0, η = η)] # i should just be rewriting the array
    for i in 1:N_steps
		new_step = gradient_descent_2d_step(f,ans[i][1],ans[i][2], η = η)
		if round.(new_step,digits=digits_to_Round) == round.(ans[i],digits=digits_to_Round)
		# if(new_step == ans[i])
			#return ans # to look at whole array 
			return new_step
		else 
        	push!(ans, gradient_descent_2d_step(f,ans[i][1],ans[i][2], η = η))
		end 
    end 

	#return ans
	return ans[end]
end
gradient_descent_2d(himmelbau, 0, 0)



import Statistics
function dice_frequencies(N_dice, N_experiments)
	
	experiment() = let
		sum_of_rolls = sum(rand(1:6, N_dice))
	end
	
	results = [experiment() for _ in 1:N_experiments]
	
	x = N_dice : N_dice*6
	
	y = map(x) do total
		sum(isequal(total), results)
	end ./ N_experiments
	
	x, y
end
dice_x, dice_y = dice_frequencies(10, 20_000)
guess_μ, guess_σ = 35.0, 5.5

function gauss(x, μ, σ)
	(1 / (sqrt(2π) * σ)) * exp(-(x-μ)^2 / σ^2 / 2)
end

"hi"
function loss_dice(μ, σ)
	total = 0
	for i in 1:length(dice_x)
		total += (gauss(dice_x[i], μ, σ) - dice_y[i]) ^ 2
	end 
	return total 
end

gradient(loss_dice,guess_μ, guess_σ)
loss_dice(guess_μ + 3, guess_σ) > loss_dice(guess_μ, guess_σ)
gradient_descent_2d_step(loss_dice,30 , 1)
let 
    @variables z, η
    zzzz = x -> ForwardDiff.derivative(a->gauss(a,0.5,0.5), x)
    zzzz(z)
	#expand(zzzz(z))
end 

found_μ, found_σ = let

	ini_μ = 30
	ini_σ = 1 
	gradient_descent_2d(loss_dice,ini_μ,ini_σ,η=100)

end


### Exercise 6: Fitting SIR model to data
spatial_T = 1:1000
let 
	β, γ = 0.0182, 0.0022
	r = euler_SIR(β, γ,[0.99, 0.01, 0.00], spatial_T)	
	plot_sir!(plot(),spatial_T, r)
end 
function loss_sir(β, γ)
	ans = zeros(3,1)
	theo = euler_SIR(β, γ,[0.99, 0.01, 0.00], spatial_T) # generates theoretical solution vec of vecs 
	for i in spatial_T
		ans += (theo[i] - spatial_results[i]) .^ 2
	end 
	
	return ans
end
for i in spatial_T
	println(i)
end 
euler_SIR(0.0182, 0.0022,[0.99, 0.01, 0.00], spatial_T)[1] - [0.99, 0.01, 0.00]
guess_β, guess_γ = 0.0182, 0.0022
loss_sir(guess_β, guess_γ)


found_β, found_γ = let
	
	# your code here
	
	missing, missing
end

[1.0, 2.0, 3.0] - [1.0, 2.0, 3.0] 