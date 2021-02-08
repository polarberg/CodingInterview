// fibonaaci
/*  
    f[0]=0 
    f[1]=1
    f[i]=f[i-1]+f[i-2] 
 */

#include <iostream> 
#include <time.h>
using namespace std;

int FibConstSpace(int n) { // 0 1 1 2 3 5 8 
    int f[2] = {0,1}; // just saves last 2 elements
    
    if(n < 2) 
        return f[n];
    
    int s = 0;
    for(int i = 2; i <= n; i++) {
        s = f[0] + f[1]; //f[i]=f[i-1]+f[i-2] 
        f[0]=f[1];
        f[1]=s; 
    }
    
    return s; // returns fib(n)
}

int FibDynProg(int n) {
    int f[n+2]; //array to store all fibonacci values
    // 0th and 1st numbers are 0 1 
    f[0] = 0;
    f[1] = 1; 
    for(int i = 2; i <= n; i++) {
        f[i] = f[i-1] + f[i-2]; // use 2 prev elem to find fib(i)
    }
    return f[n];
}

int main() {
    int n; 
    cin>>n;
    clock_t tStart = clock();
    cout << "fib const space: " << FibConstSpace(n) << endl;
    printf("\nTime taken: %.10fs\n", (double)(clock() - tStart)/CLOCKS_PER_SEC);

    tStart = clock();
    cout << "fib Dynamic Programming: " << FibDynProg(n) << endl;
    printf("\nTime taken: %.10fs\n", (double)(clock() - tStart)/CLOCKS_PER_SEC);
}