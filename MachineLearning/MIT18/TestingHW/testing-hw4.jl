begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Images", version="0.23"),
        Pkg.PackageSpec(name="ImageMagick", version="1"),
        Pkg.PackageSpec(name="TestImages", version="1"),
        Pkg.PackageSpec(name="ImageFiltering", version="0.6"),
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
        Pkg.PackageSpec(name="BenchmarkTools", version="0.6"),
    ])
    using Images, TestImages, ImageFiltering, Statistics, PlutoUI, BenchmarkTools
end

isnothing(x::Any) = x === nothing ? true : false 
import Pkg; Pkg.add("BenchmarkTools")
using BenchmarkTools

all_image_urls = [
	"https://wisetoast.com/wp-content/uploads/2015/10/The-Persistence-of-Memory-salvador-deli-painting.jpg" => "Salvador Dali — The Persistence of Memory (replica)",
	"https://i.imgur.com/4SRnmkj.png" => "Frida Kahlo — The Bride Frightened at Seeing Life Opened",
	"https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan_No._1_%2813947%29.jpg/477px-Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan_No._1_%2813947%29.jpg" => "Hilma Klint - The Swan No. 1",
	"https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Piet_Mondriaan%2C_1930_-_Mondrian_Composition_II_in_Red%2C_Blue%2C_and_Yellow.jpg/300px-Piet_Mondriaan%2C_1930_-_Mondrian_Composition_II_in_Red%2C_Blue%2C_and_Yellow.jpg" => "Piet Mondriaan - Composition with Red, Blue and Yellow",
	"https://user-images.githubusercontent.com/6933510/110993432-950df980-8377-11eb-82e7-b7ce4a0d04bc.png" => "Mario",
]

f(x) = 2x+3 
g(x) = -x^2 + 2 

(f ∘ g)(2) 
(g ∘ f)(2)

@assert 

tmpMat = size([2 3; 3 2; 1 1])

if(tmpMat[1][1])
    print("hi")
end

min(1,2,3)
minRowEnergy = typemax(typeof(energies[1][1]))
minimum([1,2,3])
zeros(4)
fill(2,4)

dims=4
tempMat = rand(0:0.1:0.9,dims,dims)

function greedy_seam(energies, starting_pixel::Int) 
    m, n = size(energies) # row, col 

    seam = zeros(Int,m) # stores cols 
    seam[1] = starting_pixel

    for rowPos in 2:m # rows 
        tmpMin = 2.0 # initialize as max value 
        for j in -1:1 # column 3 positions
            colPos = seam[rowPos-1]+j
            if(0 < colPos < n+1 && energies[rowPos, colPos] < tmpMin) # within col bounds 
                seam[rowPos] = colPos 
                tmpMin = energies[rowPos, colPos] 
            end 
        end 
    end 

    return seam 
end 

greedy_seam(tempMat, 3)
tempMat

#= function greedy_seam(energies, starting_pixel::Int)
	m,n = size(energies) # row, col 
	

	# you can delete the body of this function - it's just a placeholder.
	random_seam(size(energies)..., starting_pixel)
end =#

@inbounds tempMat[-1,1]
function t(i)
    return i
end
[if(i>0) t(i) end for i in -1:1]


begin 
    vec1 = []
    for v in -1:1
        if(v==0)
            push!(vec1,v)   
        else 
            continue   
        end 
    end 
    vec1 

    vec2 = [v for v in -1:1 if(v==0)]
end

if(checkbounds(Bool,tempMat,2,1)) 
    tempMat[2,1]
end 
u=1
v=1
checkbounds(Bool,tempMat,u,v) ? tempMat[u,v] : nothing 
tmpV = [tempMat[u,1+v] for v in -1:1 if(checkbounds(Bool,tempMat,u,1+v))]
vec = []
for v in -1 :1
    if(checkbounds(Bool,tempMat,u+1,1+v))
        push!(vec,tempMat[u+1,1+v])        
    end 
end 
vec
minimum(vec)
tempMat



function e(energies,i,j)    
    m, n = size(energies)

    if i == m 
        return (energies[i,j], j)
    end 

    return (round(energies[i,j] + e(energies,i+1,j)[1], digits=2), j)
end
e(grant_example,1,1)

minimum(tmpV)
argmin(tmpV)
length(tmpV)

tt = [(3,2), (2,3),(1,5),(10,1),(0,20)] 
minimum(tt)[1]
tt[1][2]

## returns lowest possible sum energy at pixel (i, j), and the column to jump to in row i+1.
function least_energy(energies, i, j) # (i,j) => (row, col)
	m, n = size(energies)

	## base case
	if i == m # boundary      
        #println("final row ", energies[i, j], ", pos: [", i,",",j,"]")	#Debugging 
		return (energies[i,j], j) # (lowest energy, column to jump to)       # no need for recursive computation in the base case!	 		
	end
	
	## induction
    # combine results from recursive calls to `least_energy`.
    #println(energies[i, j], ", pos: [", i,",",j,"]") #Debugging
    tmpV = [(round((energies[i, j] + least_energy(energies, i+1, j+col)[1]), digits=2), j+col) 
                for col in -1:1 if(checkbounds(Bool, energies, i+1, j+col)) ]
    minTuple = minimum(tmpV)
    minEnergy = minTuple[1]
    minCol = minTuple[2] # position of min in vector

    #println("pos:[", i,",",j,"], ", "value:", energies[i, j], ",  vec: ",tmpV, "\n\tminEnergy:", 
                #minEnergy, ", minCol:", minCol, "\n")

    return (minEnergy, minCol)
end
tempMat

et = [2,least_energy(tempMat,1,2)[2]] 
size(ans,1)
ans[size(ans,1)]
for i in 2:2
    push!(et,least_energy(tempMat,i,et[i-1])[2])
end 
et 
tempMat#
least_energy(tempMat,2,2)


### M matrix 
M = [
    4  6  6  2
    4  5  9  1
    2  1  3  2
    8  6  4  6
] 
u=1
v=4
@btime Recursive = least_energy(M,u,v)
MDict = Dict()
@btime Memoized = memoized_least_energy(M,u,v,MDict)
MDict
M
Recursive == Memoized

@btime Seam1 = recursive_seam(M, v)
@btime Seam2 = memoized_recursive_seam(M,v)
Seam1 == Seam2

NMatrixed = Matrix{Union{Nothing, Tuple{Float64,Int}}}(nothing, size(M))
@btime Matrixed = matrix_memoized_least_energy(M,u,v,NMatrixed)
matrix_memoized_seam(M,v)


grant_example = [ 
    0.1  0.8  0.8  0.3  0.5  0.4
    0.7  0.8  0.1  0.0  0.8  0.4
    0.8  0.0  0.4  0.7  0.2  0.9
    0.9  0.0  0.0  0.5  0.9  0.4
    0.2  0.4  0.0  0.2  0.4  0.5
    0.2  0.4  0.2  0.5  0.3  0.0
]
least_energy(grant_example,1,4)

mySeam = recursive_seam(grant_example, 4)
grant_example_optimal_seam = [4, 3, 2, 2, 3, 3]
mySeam == grant_example_optimal_seam

## computes the seam with the lowest energy from that starting pixel
function recursive_seam(energies, starting_pixel)
	m, n = size(energies)
    
    # run least_energy, m times...
    seam = [starting_pixel, least_energy(energies,1,starting_pixel)[2]] # tuple with lowest energy seam, next position to look
    if(m>2)
        for i in 2:m-1
            push!(seam,least_energy(energies,i,seam[i])[2])
        end          
    end 

    return seam
end
RecursiveSol = recursive_seam(grant_example, 4)
grant_example_optimal_seam = [4, 3, 2, 2, 3, 3]
RecursiveSol == grant_example_optimal_seam


### Memoization
#Dictionary 
begin # Dictionary: test cases  
    dict1 = Dict((1,1) => (1.0,5), (1,2) => (2.5,2))
    dict1[(2,1)] = (10.0,1)
    dict1
    haskey(dict1, "girls")
    dict1[(1,1)][1]
end

## returns lowest possible sum energy at pixel (i, j), and the column to jump to in row i+1.
function memoized_least_energy(energies, i, j, memory::Dict) # (i,j) => (row, col)
	m, n = size(energies)    

	## base case
	if i == m # boundary         
		return memory[(i,j)] = (energies[i,j], j) # (lowest energy, column to jump to)
	end
	
	## induction
    # combine results from recursive calls to `least_energy`. # memory[(i,j)][2] ???
    tmpV=[]
    for col in -1:1 
        if (0<i+1<=m && 0<j+col<=n)  #checkbounds(Bool, energies, i+1, j+col))
            if haskey(memory, (i+1, j+col))
                push!(tmpV, (energies[i, j] + memory[(i+1,j+col)][1], j+col) ) 
            else 
                push!(tmpV, ((energies[i, j] + memoized_least_energy(energies, i+1, j+col, memory)[1]), j+col) )
            end 
        end 
    end 
    minTuple = minimum(tmpV)
    minEnergy = minTuple[1]
    minCol = minTuple[2] # position of min in vector
    memory[(i,j)] = (minEnergy, minCol) # create entry 
    #println("pos:[", i,",",j,"], ", "value:", energies[i, j], ",  vec: ",tmpV, "\n\tminEnergy:", 
                #minEnergy, ", minCol:", minCol, "\n")

    return memory[(i,j)]
end
memoized_least_energy_test = memoized_least_energy(grant_example, 1, 4, Dict())



function memoized_e(energies,i,j, memory::Dict)    
    m, n = size(energies)

    if i == m 
        memory[(i,j)] = (energies[i,j], j)   
        return memory[(i,j)]

#=     elseif (haskey(memory, (i+1,j)))
        return (energies[i,j] + memory[(i,j)], j)
    else 
        return (energies[i,j] + e(energies,i+1,j)[1], j) =#
    end 

    return [haskey(memory, (i+1,j)) ? (energies[i,j] + memory[(i,j)][1], j) : (energies[i,j] + memoized_e(energies,i+1,j, memory)[1], j) 
        for a in [1]
        ][1]
end
eDict = Dict()
memoized_e(M,1,2,eDict)
M


function memoized_recursive_seam(energies, starting_pixel)
	# we set up the the _memory_: note the key type (Tuple{Int,Int}) and
	# the value type (Tuple{Float64,Int}). 
	# If you need to memoize something else, you can just use Dict() without types.
	memory = Dict{Tuple{Int,Int},Tuple{Float64,Int}}()	
	m, n = size(energies)
	
	# Replace the following line with your code.	
    # run least_energy, m times...
    seam = [starting_pixel, memoized_least_energy(energies,1,starting_pixel,memory)[2]] # tuple with lowest energy seam, next position to look
    if(m>2)
        for i in 2:m-1
            push!(seam,memory[i,seam[i]][2]) # iterate through next positions 
        end          
    end 

    return seam
end


function matrix_memoized_least_energy(energies, i, j, memory::Matrix)
	m, n = size(energies)
	
    ## base case
    if i == m # boundary         
        return memory[i,j] = (energies[i,j], j) # (lowest energy, column to jump to) *** Took out (i,j)
    end
    
    ## induction
    tmpV=[]
    for col in -1:1 
        if (0<i+1<=m && 0<j+col<=n)  #checkbounds(Bool, energies, i+1, j+col))
            if memory[i+1,j+col] != nothing 
                push!(tmpV, (energies[i, j] + memory[i+1,j+col][1], j+col) ) 
            else 
                push!(tmpV, ((energies[i, j] + matrix_memoized_least_energy(energies, i+1, j+col, memory)[1]), j+col) )
            end 
        end 
    end 
    minTuple = minimum(tmpV)
    minEnergy = minTuple[1]
    minCol = minTuple[2] # position of min in vector
    memory[i,j] = (minEnergy, minCol) # create entry *** Took out (i,j)
    #println("pos:[", i,",",j,"], ", "value:", energies[i, j], ",  vec: ",tmpV, "\n\tminEnergy:", 
                #minEnergy, ", minCol:", minCol, "\n")

    return memory[i,j]
end

# NMatrix[1,1] = (1,2)

function matrix_memoized_seam(energies, starting_pixel)
	memory = Matrix{Union{Nothing, Tuple{Float64,Int}}}(nothing, size(energies))

	# use me instead of you use a different element type:
	# memory = Matrix{Any}(nothing, size(energies))		
	m, n = size(energies)
	
	# Replace the following line with your code.
    seam = [starting_pixel, matrix_memoized_least_energy(energies,1,starting_pixel,memory)[2]] # tuple with lowest energy seam, next position to look
    if(m>2)
        for i in 2:m-1
            push!(seam,memory[i,seam[i]][2]) # iterate through next positions 
        end          
    end 

    return seam
end


### Dynamic programming without recursion 
# takes the energies and returns the least energy matrix 
    # which has the least possible seam energy for each pixel
function least_energy_matrix(energies)
	result = copy(energies)
	m,n = size(energies)
	
	for i in 1:m-1, j in 1:n # rows,cols (last row values already done, don't change)
        #print((m-i,j))
        tmpV=[]
        for col in -1:1 # calculating 3 children 
            if (0<j+col<=n) 
                push!(tmpV, result[m-i+1,j+col])
            end 
        end 
        #println("\tsum:",result[m-i,j],"+",minimum(tmpV),"=",minimum(tmpV)+result[m-i,j])
        result[m-i,j] += minimum(tmpV) # min of 3 children 
    end
        
	return result
end
M
least_energy_matrix(M)

# Given the matrix returned by least_energy_matrix and 
    # a starting pixel (on the first row), computes the least energy seam from that pixel.
function seam_from_precomputed_least_energy(energies, starting_pixel::Int)
	least_energies = least_energy_matrix(energies)
	m, n = size(least_energies)
	
    seam = [starting_pixel]
	for i in 2:m
        tmpV = []
        j = seam[i-1] 
        for col in -1:1       
            if 0<j+col<n+1 # if col in bounds 
                push!(tmpV, (least_energies[i,j+col], j+col)) # (val,col)
            end 
        end 
        push!(seam, minimum(tmpV)[2]) 
    end 

    return seam 
end

seam_from_precomputed_least_energy(M, v)