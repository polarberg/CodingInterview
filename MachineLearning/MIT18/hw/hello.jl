function t(i)
    return [t for t in 1:i]
end 

t(3)
import Pkg; Pkg.add("Debugger")
using Debugger
@enter t(3)