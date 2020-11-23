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

int main() {
    ;
    cout << (KnapsackBitset() ? "\ntrue" : "\nfalse");
}