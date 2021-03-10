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


