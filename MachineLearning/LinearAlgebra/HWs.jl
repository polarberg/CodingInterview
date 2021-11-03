# 3.1 Add AB to AC and compare with A(B+C)

let 
    A= [
        1   2
        3   4
    ]
    B= [
        1   0
        0   0
    ]
    C=[ 
        0   0
        5   6
    ]
    A*B+A*C, A*(B+C)
end 

let #inv
    A=[
        1   0   0
        -2  1   0
        4   -3  1
    ]
    #inv(A)
    A |> inv
end 

let #inv
    A=[
        0   0   1
        1   0   0
        0   1   0
    ]
    #inv(A)
    B=[
        1   0   0   0
        0   0   0   1
        0   1   0   0
        0   0   1   0
    ]
    B^4
end

