using Core: Complex
using BenchmarkTools: filter
z -> z^2 + c 
z(2)

for(i=1:10)


imag(10im)

range(1, step=5, stop=100)
1:5:96
range(1, 10, length=101)
range(0im, 10im, step=1im)
sqrt(Complex(-1))

reduce()
let 
    a = 1; b = 2; complex(a, b)
end 

abs(Complex(-2,0)) > 2
function linspace(start::Complex, finish::Complex, n::Integer, m::Integer)
    realParts = range(real(start), real(finish), length=n)
    complexParts = [Complex(0, b) for b=range(imag(start), imag(finish), length=m)]
    [ a + b for a=realParts, b=complexParts ]
end
linspace(-2.5-1.25im, 1.0+1.25im, 5, 3)

function inMandelbrot_Set()
    
end
inMandelbrot_Set()


function n_steps(c::Complex) # number of steps interating 0 under z^2 +c until >2 
    m(z) = z^2 + c 
    start = 0
    A = [m(start)]
    for i in 1:10000000 
        if real(A[i]) > 2.0
            return size(A)
        else 
            push!(A,m(A[i]))
		end 
	end
end 

rand(ComplexF64, 1, 2)






Threads.nthreads()

function F(n)
           if n < 2
               return n
           else
               return F(n-1)+F(n-2)
           end
       end

function fib(n::Int)
           if n > 23
              t = Threads.@spawn fib(n - 2)
              return fib(n - 1) + fetch(t)
           else
              return F(n)
           end
       end

using BenchmarkTools
@btime F(46)
@btime fib(46)