begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Images", version="0.22.4"), 
			Pkg.PackageSpec(name="ImageMagick", version="0.7"), 
			Pkg.PackageSpec(name="PlutoUI", version="0.7"), 
			Pkg.PackageSpec(name="HypertextLiteral", version="0.5")
			])

	using Images
	using PlutoUI
	using HypertextLiteral
end
import Pkg; Pkg.add("BenchmarkTools")
using BenchmarkTools
isnothing(x::Any) = x === nothing ? true : false 
# symbols: https://docs.julialang.org/en/v1/manual/unicode-input/ 
# https://github.com/JuliaCI/BenchmarkTools.jl

url = "https://user-images.githubusercontent.com/6933510/107239146-dcc3fd00-6a28-11eb-8c7b-41aaf6618935.png"
philip_filename = download(url)

philip = load(philip_filename)
philip_head = philip[470:800, 140:410]

philip_size = size(philip)
philip_height = philip_size[1]
philip_width = philip_size[2]

function get_red(pixel::AbstractRGB)
	# your code here!
	return pixel.r
end

get_red(RGB(0.8, 0.1, 0.0))

function get_reds(image::AbstractMatrix)
	# your code here!
    isize = size(image)
	height = isize[1]
    width = isize[2]
    ans = zeros(height, width)
	ans = Float64.(get_red.(image))

	return ans
end


get_reds(philip_head)

avg_color = RGB(0.0, 0.0, 0.0) # initialize 
avg_color.r

function mean(x)
	# your code here!
	avg = 0
	for i in x
		avg += i
	end
	avg /= length(x)
	return avg
end

function get_green(pixel::AbstractRGB)
	# your code here!
	return pixel.g
end
function get_greens(image::AbstractMatrix)
	# your code here!
    isize = size(image)
	height = isize[1]
    width = isize[2]
    ans = zeros(height, width)
	ans = Float64.(get_green.(image))

	return ans
end
function get_blue(pixel::AbstractRGB)
	# your code here!
	return pixel.b
end
function get_blues(image::AbstractMatrix)
	# your code here!
    isize = size(image)
	height = isize[1]
    width = isize[2]
    ans = zeros(height, width)
	ans = Float64.(get_blue.(image))

	return ans
end

function mean_color(image)
	# your code here!
	r = mean(get_reds(image))
	g = mean(get_greens(image))
	b = mean(get_blues(image))
	
	return RGB(r,g,b)
end

mean_color(philip)

mean(get_reds(philip_head))


# Exercise 3.1
#Write a function invert that inverts a color, i.e. sends (r,g,b) to (1-r,1-g,1-b)
function invert(color::AbstractRGB)
	# your code here!
	r = get_red(color)
	g = get_green(color)
	b = get_blue(color)
	
	return RGB(1-r,1-g,1-b)
end

function quantize(x::Number)
	# your code here!
	# x is 0.267 * 10 = 2.67 
	# round down : 2.0
	# divide by 10 to get multiple of 0.1 : 0.2 
	
	return floor(x*10)/10
end

function quantize(color::AbstractRGB)
	# your code here!
	r = floor(10*get_red(color))   / 10
	g = floor(10*get_green(color)) / 10
	b = floor(10*get_blue(color))  / 10
	
	return RGB(r,g,b)
end

tmp = quantize(RGB(.155 ,.267 ,.789))
tmp.r,tmp.g,tmp.b


#= Exercise 3.4
👉 Write a method quantize(image::AbstractMatrix) that quantizes an image by quantizing each pixel in the image. 
(You may assume that the matrix is a matrix of color objects.) =#
function quantize(image::AbstractMatrix)
	# your code here!	
	return quantize.(image)
end
quantize.(philip)

function noisify(x::Number, s)
	# your code here!
	return s==0 ? x : clamp(x+rand(-s: s/100 :s), 0, 1) # checks for s==0
end
noisify(0.5, 0.1) # edit this test case!
rand(-0.1 : 0.1 / 100 : 0.1)


function noisify(color::AbstractRGB, s)
	# your code here!
	r = noisify(color.r, s)
	g = noisify(color.g, s)
	b = noisify(color.b, s)
	return RGB(r,g,b)
end

a=[1,2,3,4]
size(a)

function above_10000(n, sum)
	if(n>10000) 
		for i in 1:n^3
			sum += 1 
		end
	else 
		for i in 1:n^4
			sum += 1
		end
	end

	return sum
end

@benchmark above_10000(1000,0)
@benchmark above_10000(5000,0)
@benchmark above_10000(10000,0)
@benchmark above_10000(20000,0)
@benchmark above_10000(40000,0)
@benchmark above_10000(10000000000000,0)


function extend(v::AbstractVector, i)
	if(0 < i < length(v))
		return v[i]
	elseif (i < 1)
		return v[1]
	else	# greater than 1:n  
		return v[length(v)]
	end
end

extend([5,6,7], 1)
extend([5,6,7], -8)
extend([5,6,7], 10)
[[5,6,7],[1,2,3],[11,12,13]]
extend(extend([[5,6,7],[1,2,3],[11,12,13]], -1), -1)

test = rand(3,3)
function extend(M::AbstractMatrix, i, j)
	num_rows, num_columns = size(M)
	in_Rows_Range = (0 < i < num_rows)
	in_Col_Range = (0 < j < num_columns)
	if in_Rows_Range
		return M[i,(j<0 ? 1 : num_columns)]
	elseif in_Col_Range
		return M[(i<0 ? 1 : num_rows), j]
	elseif (in_Rows_Range && in_Col_Range)
			return v[i,j]
	else # both out of bounds 
		return M[(i<0 ? 1 : num_rows),(j<0 ? 1 : num_columns)]
	end 
end
test
extend(test, 4,4)

function box_blur(v::AbstractArray, l)
	# every element the average of it's neighbors from -l to l 	
	a = Float64.(copy(v))
	for i in 1:length(a) 
		tmpSum = 0
		for j in -l:l
			tmpSum += extend(v, i+j) # look at original values but change copy
		end 
		a[i] = tmpSum / (2*l + 1) # calculates mean with range -l:l
	end 
	return a 
end

example_vector = [0.8, 0.2, 0.1, 0.7, 0.6, 0.4]
box_blur(example_vector, 1)
extend(example_vector, 2)

function convolve(v::AbstractVector, k)
	a = Float64.(copy(v))
	l =  (length(k)-1)÷2 # 2l+1=length(k): length of vector k
	for i in 1:length(v) # for each i, a[i] = ⅀v[j]*k 
		tmpSum = 0
		for j in -l:l
			tmpSum += extend(v, i+j) * k[j+(l+1)] # k[i,m] * [m,n] = [i,n]
		end 
		a[i] = tmpSum  # calculates mean with range -l:l
	end 
	return a
end

(length([1, 1, 0])-1)÷2
extend([1, 10, 100, 1000, 10000], -1) * [1, 1, 0]

test_convolution = let
	v = [1, 10, 100, 1000, 10000]
	k = [1, 1, 0]
	convolve(v, k)
end

function box_blur_kernel(l)
	
	return [1/(2l+1) for i in 1:(2l+1)] # returns kernal for convolve 
end

box_blur_kernel(1)
n = 50
v = rand(n)
box_kernel_l=1
box_blur_kernel_test = box_blur_kernel(box_kernel_l)
let
	result = convolve(v, box_blur_kernel_test)
	#colored_line(result)
end

result = box_blur_kernel(2)

x = [1, 10, 100]
result1 = box_blur(x, 2)


a = Float64.(copy(x))
for i in 1:length(a) 
	tmpSum = 0
	for j in -2:2
		tmpSum += extend(x, i+j) # look at original values but change copy
	end 
	a[i] = tmpSum / (2*2 + 1) # calculates mean with range -l:l
end 
a 

result2 = convolve(x, result)
result1 ≈ result2


gauss(x::Real; σ=1) = 1 / sqrt(2π*σ^2) * exp(-x^2 / (2 * σ^2))

function gaussian_kernel_1D(n; σ = 1)
	ans = zeros(Float64,2n+1)
	total = 0
	for i in 1:2n+1 
		ans[i] = gauss(i) # calculate gauss(n) for each position 
		total += ans[i] # creating denominator to divide by 
	end

	return ans ./ total # normalize each n 
end
gauss(5.0)
gaussian_kernel_1D(5)


function convolve(v::AbstractVector, k)
	a = Float64.(copy(v))
	l =  (length(k)-1)÷2 # 2l+1=length(k): length of vector k
	for i in 1:length(v) # for each i, a[i] = ⅀v[j]*k 
		tmpSum = 0
		for j in -l:l
			tmpSum += extend(v, i-j) * k[j+(l+1)] # k[i,m] * [m,n] = [i,n]
		end 
		a[i] = tmpSum  # calculates mean with range -l:l
	end 
	return a
end


function convolve(M::AbstractMatrix, K::AbstractMatrix)
	knR, knC = size(K) .÷ 2 # length of rows and cols of kernal (5÷2=2) ; 2l+1=length(k): length of vector k
	convolved = [
		sum(extend(M, i+m, j+n) * K[m+(knR+1), n+(knC+1)] for m in -knR:knR, n in -knC:knC) # row, col... Difference from A to K matrix is (x+1)
			for i ∈ 1:size(M,1), j ∈ 1:size(M,2) # for every elem in matrix; size(M) = (rows,cols)
	]
	return convolved
end

test2 = rand(3,3)
p=3
N = 2(p) + 1
[(j,i)  for i in -p:p, j in -p:p]
[(j,i)  for i in 1:N, j in 1:N]

#Test 
small_image = Gray.(rand(5,5))
test_image_with_border = [get(small_image, (i, j), Gray(0)) for (i,j) in Iterators.product(-1:7,-1:7)]
K_test = [
	0   0  0
	1/2 0  1/2
	0   0  0
]
function convolve(M::AbstractMatrix, K::AbstractMatrix)
    lr, lc = size(K) .÷ 2
    convolved = [sum([extend(M, i - m, j - n) * K[m + lr + 1, n + lc + 1] 
					for m ∈ -lr:lr, n ∈ -lc:lc]) 
				for i ∈ 1:size(M, 1), j ∈ 1:size(M, 2)]
    return convolved
end

typeof(test_image_with_border)
m=convolve(test_image_with_border, K_test)
typeof(m)
typeof(test_image_with_border)
convolve(philip_head, K_test)
typeof(philip_head)
size(philip_head)

gauss(x, y; σ=1) = 2π*σ^2 * gauss(x; σ=σ) * gauss(y; σ=σ)


function gaussian_kernel_2D(l; σ = 3)
	ans = [gauss(i,j,σ=σ) for i in -n:n, j in -n:n]

	return ans ./ sum(ans) # normalize each n
end 

function with_gaussian_blur(image; σ=3, l=5)
	k = gaussian_kernel_2D(l,σ=σ)
	return convolve(image, k)
end


function convolve(M::AbstractMatrix, K::AbstractMatrix)
    lr, lc = size(K) .÷ 2
    convolved = [sum([extend(M, i - m, j - n) * K[m + lr + 1, n + lc + 1] 
					for m ∈ -lr:lr, n ∈ -lc:lc]) 
				for i ∈ 1:size(M, 1), j ∈ 1:size(M, 2)]
    return convolved
end
with_gaussian_blur(philip)
