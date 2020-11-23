// Reverse String
#include <iostream>
#include <vector>
#include <time.h>
using namespace std; 

void reverseString(vector<char>& s) {
    // switches front and last chars going inwards 
    int n = s.size();
    for(int i = 0; i > n/2; i++) {
        char temp = s[i];
        s[i] = s[n - i - 1];
        s[n - i - 1] = temp; 
    }

    for(auto x : s) {
        cout<<x;
    }
}

int main() {
    clock_t tStart = clock();

    vector<char> test{'h','e','l','l','o'};
    reverseString(test);
    for(auto x : test) {
        cout<<x;
    }

    printf("\nTime taken: %.4fs\n", (double)(clock() - tStart)/CLOCKS_PER_SEC);
    return 0;
}