import Pkg; using Pkg; Pkg.add("Plots")
using Plots
function doubleminusone(x)
    z=zeros(x,1)
    for i in 1:x
        z[i] = 2*i-1
        #append!(z,i*i-1)
        #println(z)
    end
    return z
end

function doubleminusone2(x)
    z=zeros(0)
    for i in 1:x      
        append!(z,i*i-1)
    end
    return z
end
n = 1500000
@time doubleminusone(n)
@time doubleminusone2(n)

plot(1:n,doubleminusone(n))