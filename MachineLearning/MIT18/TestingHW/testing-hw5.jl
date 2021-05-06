using BenchmarkTools
# using Comprehension 
@btime [j for j in 1:1000 if(j*(1/j)!=1)] 

# using filter 
function formula(j) 
    return (j*(1/j))!=1
end 
@btime filter(formula, 1:1000)

log2()

begin
	struct FirstRankOneMatrix
		# Your code here
		v::Vector{Float64}
		w::Vector{Float64}
	end
	
	# Add the extra constructor here
	FirstRankOneMatrix(v) = FirstRankOneMatrix(v, v)
end
ten_twelve = FirstRankOneMatrix(1:10,1:12) # Your code here

function Base.size(M::FirstRankOneMatrix)

	return ( size(M.v,1),size(M.w,1) ) # Your code here
end
Base.size(ten_twelve)

function Base.getindex(M::FirstRankOneMatrix, i, j)
	
	return M.v[i] * M.w[j] # Your code here
end
Base.getindex(ten_twelve, 5, 11)

function print_as_matrix(M::FirstRankOneMatrix)
	padding = 6
	# Your code here
	for x in M.v
		for y in M.w
            
            print(rpad(lpad(x*y,padding),padding))
		    #print(x * y, " ")
		end
	println()
	end 
end

print_as_matrix(ten_twelve)
string(2)
lpad(2,2)
rpad(2,2)


 
begin
	struct RankOneMatrix{T} <: AbstractMatrix{T} # using vectors instead of int 
		v::AbstractVector{T}
		w::AbstractVector{T}
	end
	
	# Add the two extra constructors
	# (Should we make these missing by default? if so - remove hint below)
	RankOneMatrix(v) = RankOneMatrix(v, v)
end

function Base.size(M::RankOneMatrix)
	
	return ( size(M.v,1),size(M.w,1) )   # Your code here
end
function Base.getindex(M::RankOneMatrix, i, j)
	
	return M.v[i] * M.w[j] # Your code here
end
RankOneMatrix(1.0:10.0, 1.0:12.0)
R2 = RankOneMatrix([1,2], [3,4,5])
M = RankOneMatrix(1:10)
collect(M)
typeof(collect(M))


# Define a function matvec that takes a RankOneMatrix M and a Vector x
# and carries out matrix-vector multiplication. 
function matvec(M::RankOneMatrix, x)
		#w*x is a scalar, times each element in vector 
	return  sum( M.w .* x ) * M.v # MatMul VxW * Wx1 = Vx1, 
end

function matvec2(M::RankOneMatrix, x)
	
	return [ sum( M.w .* x ) ] .* M.v # MatMul VxW * Wx1 = Vx1 
end
@btime matvec(R2,[1,2,3])
@btime matvec2(R2,[1,2,3])
@btime [sum(R2.w .* [1,2,3])] .* R2.v
@btime [3 4 5; 6 8 10] * [1; 2; 3]
@btime [3 4 5] * [1; 2; 3] .* [1,2]
# 1x3 * 3x1 
2 * [1; 2; 3]

size(R2)
R2[1][1]


### RANK 2 Matrix 
begin
	struct RankTwoMatrix{T} <: AbstractMatrix{T} # rank 2 matrix is 2 rank 1 matricies added together
		# Your code here
		A::RankOneMatrix{T}
		B::RankOneMatrix{T}
	end
	
	# Add a constructor that uses two vectors/ranges
	RankTwoMatrix(v1, v2) = RankTwoMatrix(RankOneMatrix(v1), RankOneMatrix(v2))
end

function Base.getindex(M::RankTwoMatrix, i, j)

	return M.A[i,j] + M.B[i,j] # Your code here
end

function Base.size(M::RankTwoMatrix)
	
	return (size(M.A)) # Your code here
end

RankTwoMatrix(1.0:10.0, 0.0:0.1:0.9)


### Rank 3, 4,... matrices ... rank-k matrix 
#= store two main things: 
	the list of rank-1 matrices that our low-rank matrix is made up of, 
	and also the rank of the matrix (which is how many rank-1 matrices we are storing) =#
struct LowRankMatrix <: AbstractMatrix{Float64}
	# Your code here
	Ms::Vector{RankOneMatrix}
	rank::Int
end

function Base.getindex(M::LowRankMatrix, i, j)
	total = 0.0
	# iterate thru M.Ms
	for v in 1:M.rank # number of rank 1 matrices 
		total += M.Ms[v][i,j]
	end
	#total += M.Ms[:][i,j]
	return total # Your code here
end

function Base.size(M::LowRankMatrix)
	
	return size(M.Ms[1]) # Your code here
end


	comp1, comp2 = RankOneMatrix(1.0:1.0:10.0), RankOneMatrix(0.0:0.1:0.9)
	comp1.v .* X
	ex3 = LowRankMatrix([comp1, comp2], 2)
ex3.Ms[1].v .* X

function matvec(M::LowRankMatrix, x)
	# each RankOneMatrix
	answer = [] # final 10x1 matrix 
	
	for row in 1:size(M,1) # each row 
		tmpF = 0.0
		for vec in M.Ms
			tmpF += matvec(vec,x)[row] 
		end 
		push!(answer, tmpF)
	end 

	return answer 	
	#return [ sum([matvec(vec,x)[row] for vec in M.Ms]) for row in 1:size(M,1)]
end

ex3
ex3.Ms[1]
matvec(ex3.Ms[1],X)[3]
matvec(ex3.Ms[2],X)[3]
X=[2 for o in 1:10]
matvec(ex3,X)


tmplrm= LowRankMatrix([RankOneMatrix([1,2,3]),RankOneMatrix([1,2,3])],2)
matvec(tmplrm,[1,2,3])

comp1, comp2 = RankOneMatrix(1.0:1.0:10.0), RankOneMatrix(0.0:0.1:0.9)
ex4 = LowRankMatrix([comp1, comp2], 2)
collect(ex4) * ones(10).*2 # correct answer 
matvec(ex4, ones(10).*2)




using LinearAlgebra
biggie = rand(100,100)
svd(biggie)

A = RankOneMatrix(rand(3),rand(4))
MatA = [A[i,j] for i in 1:size(A,1), j in 1:size(A,2)]
svd(MatA)
svd([A[i,j] for i in 1:size(A,1), j in 1:size(A,2)])

function LinearAlgebra.svd(A::RankOneMatrix)
	tmpA = [A[i,j] for i in 1:size(A,1), j in 1:size(A,2)]
	return svd(tmpA)
end
# calculates the singular values of matrix A, returns how many are approximately zero 
function numerical_rank(A::AbstractMatrix; tol=1e-5)
	
	return count(i->(i<tol), svd(A).S)
end
numerical_rank(MatA)


function k_rank_ones(k, m, n)
	
	return sum(RankOneMatrix(rand(m),rand(n)) for i in 1:k) # returns RankOneMatrix{Float64}
end
k_rank_ones(1, 3, 3)


numerical_rank(k_rank_ones(1,3,3))
numerical_rank(k_rank_ones(5,6,4))