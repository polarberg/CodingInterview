// Subarray Sum Equals K
/*  Given an array of integers nums and an integer k, 
    return the total number of continuous subarrays whose sum equals to k. */


#include <iostream>
#include <vector>
#include <unordered_map>

using namespace std; 
        
class Solution {      
public:
    int subarraySum(vector<int>& nums, int k) {
        //subarray[L..R] = pref[R] - pref[L-1] 
        int n = nums.size();
        int answer = 0;
        int pref = 0; 
        unordered_map<int,int> countPref;   // linear complexity      
        countPref[pref]++; // consider empty prefix 
        for(int R = 0; R < n; R++) {
            //pref[R]-pref[L-1]=k   I know pref[R] bc we are at R
            //pref[L-1]=pref[R]-k;  Need pref[L-1]
            pref += nums[R]; // sum of numbers up to current position r
            int need = pref - k; 
            answer += countPref[need];            
            countPref[pref]++; 
        }
        for(auto x:countPref) {
            cout << '(' << x.first << ',' << x.second << ')' << endl;
        }

        return answer; 
    }
};

int main() {
    Solution test;
    vector<int> nums {1,1,1};
    int k = 2;
    /* Constraints  
    1 <= nums.length <= 2 * 10^4
    -1000 <= nums[i] <= 1000
    -107 <= k <= 107 
    */

    int answer = test.subarraySum(nums, k);
    cout << "answer: " << answer; // expected output: 2
}