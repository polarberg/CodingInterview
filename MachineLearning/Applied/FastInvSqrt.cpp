#include <iostream>
#include <math.h>
#include <time.h>

using namespace std; 

class Solution {
    public:
        float FastInvSqrt(float number) { 
            long i; 
            float x2, y; 
            const float threehalfs = 1.5F; 

            x2 = number * 0.5F; 
            y = number;
            i = * ( long * ) &y; 
            i = 0x5f3759df - (i >> 1); 
            y = * ( float * ) &i; 
            y = y * (threehalfs - ( x2 * y * y) );
            // y = y * (threehalfs - ( x2 * y * y) );
            return y; 
        }
};

int main() {


    Solution test;
    float x; 
    cout << "Input a Float (0<x<1): ";
    cin >> x; 

    clock_t start = clock();
    float FIST = test.FastInvSqrt(x);
    // Stop measuring time and calculate the elapsed time
    clock_t end = clock();
    double elapsed = double(end - start)/CLOCKS_PER_SEC;
    printf("Time measured: %.28f seconds.\n", elapsed);

    start = clock();
    float originalSqrt = 1 / sqrt(x);
    end = clock();
    elapsed = double(end - start)/CLOCKS_PER_SEC;
    printf("Time measured: %.28f seconds.\n", elapsed);




    cout << "FastInvSqrt(x): " << FIST << endl;
    cout << "Math.h Sqrt(x): " << originalSqrt << endl;

    float difference = FIST - originalSqrt; 
    cout << "Difference: " << difference << endl;

    float Error = 100 * (originalSqrt - FIST) / originalSqrt;  // Percentage 
    cout << "Error: " << Error;
}