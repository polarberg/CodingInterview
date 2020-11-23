/* You are given N numbers. 
Check if there is a subset of them, with the sum equal to target value S 
n<=20
*/
#include <iostream> 
#include <vector> 
using namespace std;

bool subsetSum(vector<int> nums, int target) {
    unsigned int n = 30; 

    for(int mask = 0; mask < (1 << n); mask++) {
        long long sum_of_this_subset = 0; 
        for(int i = 0; i < n; i++) {
            if(mask & (1 << i)) { // if(x != 0) 
                sum_of_this_subset += nums[i]; 
            }
        }
        if (sum_of_this_subset == target) 
        {
            return true; 
        }        
    }
    return false;
}


int main() {
    vector<int> nums {}
}
