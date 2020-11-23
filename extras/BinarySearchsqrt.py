def BSsqrt(x):
    L=0
    R=x 
    eps=10**-9
    while R - L > eps:
        mid = L + (R-L) / 2
        if mid*mid < x:
            L = mid
        else:
            R = mid
    return L + (R-L) / 2

print(BSsqrt(49))
print(BSsqrt(.25))
#doesn't work for fractions... yet