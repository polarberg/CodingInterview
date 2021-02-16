// Bitsets 
#include <iostream>
#include <bitset>   
using namespace std;

bitset<30> dp; 
//__builtin_popcount(x);
bool KnapsackBitset() { // o(N * T/32(sizeofInt))
    int n, T; // n: numbers, W: target 
    cout << "Num of nums, Target\n";
    cin >> n >> T; 
    dp[0] = true; 
    for(int id = 0; id < n; id++) {
        int x; 
        cin >> x; 
        dp |= (dp << x); // when adding a new number shift all current 1's to right 
    }
    return dp[T] ? true : false; 
}

int TrianglesInGraph() {
    /*compute intersection 1
                           | \
                           |  3
                           | /
                           2
    */
}

// Given N<=10^7 numbers, each between 0 and 10^9.
// How many different values appear in the sequence 
/* bitset<1000000001> visited;
int DifferentNums() { 
    int n = sizeof(arr);
    for(int i = 0; i < n; i++) {
        int x; 
        cin>>x;
        visited[x] = true;
    }
    return visited.count(); // O((size of bitset) / (size of int)) 
} */

int main() {
    ;
    cout << (KnapsackBitset() ? "\ntrue" : "\nfalse");
}