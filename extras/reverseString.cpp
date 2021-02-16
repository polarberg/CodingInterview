// Reverse String
#include <iostream>
#include <vector>
#include <time.h>
using namespace std; 

#define print(test) for(auto x : test) {cout<<x;}

void reverseString(vector<char>& s) {
    // switches front and last chars going inwards 
    int n = s.size();
    for(int i = 0; i < n/2; i++) {
        auto temp = s[i];       // left
        s[i] = s[n - i - 1];    // replace left with right 
        s[n - i - 1] = temp;    // replace right with left
    }
    return;
}

//void reverseS(vector<char>)
int main() {
    clock_t tStart = clock();

    vector<char> test{'h','e','l','l','o'};
    //for(auto x : test) {cout<<x;}
    print(test)
    cout<<endl;
    
    reverseString(test);
    print(test)

    printf("\nTime taken: %.7fs\n", (double)(clock() - tStart)/CLOCKS_PER_SEC);
    return 0;
}
