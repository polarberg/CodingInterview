function binarysqrtapprox(x)
    if(x==0 || x==1)
        return x
    end 

    # do binary search 

end 


function cbrtapprox(x)
    # initialize variables 
    guess = 0.0
    counter = 1 
    increment = 0.01

end

function cbrtbinarysearch(x)
    # initialize variables 
    low = 0
    high = x 
    guess = (low + high) / 2
    counter = 1 
    error = 1 

    # algorithm 
    while abs(guess^3  - x) >= error # while error not within range 
        println(counter, "\tGuess = $guess\tGuess Cubed = $(guess^3)\n$(guess^3)<$x: $(guess^3<abs(x))")
        if abs(guess^3) < abs(x)
            low = guess
        else 
            high = guess 
        end 
        guess = (low + high) / 2 
        counter += 1
    end 

    # display result
    println(counter, "\tGuess = $guess\tGuess Cubed = $(guess^3)")
    guess = round(guess, digits = 1)
    println("\nThe cub root of $x is $guess")
    
end

cbrtbinarysearch(27)

