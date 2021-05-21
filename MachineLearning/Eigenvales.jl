using Pkg
Pkg.add("LinearAlgebra")
using LinearAlgebra, BenchmarkTools

A = [1 2 3; 4 1 6; 7 8 1]
eigvals(A)
eigvecs(A)

B = [
    3 1 
    0 2
]
eigvals(B)
eigvecs(B)


p = det(B)
(m + √(m^2-p),m - √(m^2-p))

function eigval_Shortcut(M::Matrix)
    m=0
    for i in 1:length(M[:,1])
        m += M[i,i]
    end 
    m /= length(M[:,1]) # mean 

    p = det(M)

    return (m + √Complex(m^2-p),m - √Complex(m^2-p))
end 
eigval_Shortcut(C)

D = [
    0 -1
    1 0
]
eigval_Shortcut(D)
eigvals(D)
eigvecs(D)
sqrt(2)/2
C = 
[
    1 0 0
    0 2 0
    0 0 3
]
eigvals(C)
eigvecs(C)




E = [
    1  -1
    0 1
]
F = [ 
    3 1 
    0 2 
]
eigvecs(F)
@btime 
@btime E * (E^-1 * F * E )^20 * E^-1
@btime F^20
@btime 

