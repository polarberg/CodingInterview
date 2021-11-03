// https://leetcode.com/problems/product-of-array-except-self/

#include <iostream>
#include <vector>
#include <unordered_set>
#include <string>

using namespace std; 

class Solution {
public:
    vector<int> productExceptSelf(vector<int>& nums) {
        /*
        Given       [1,2,3,4]
        PrefProd    [1,1,2,6,24]   create left to right
        SufProd     [24,24,12,4,1] create right to left
        */
                
        const int n = nums.size();
        vector<int> pref_product; // Prefix Product [1,1,2,6,24]
        pref_product.push_back(1);
        for(int x : nums) {
            pref_product.push_back(pref_product.back() * x); 
        }
        
        vector<int> suf_product(n+1); // Suffix Product 
        suf_product[n] = 1;
        for(int i = n - 1; i >= 0; --i) {
            suf_product[i] = suf_product[i+1] * nums[i];
        }
        
        vector<int> answer(n);
        for(int i = 0; i < n; i++) {
            answer[i] = pref_product[i] * suf_product[i+1];
        }
        
        return answer;
    }
};

int main() {
    Solution test; 
    vector<int> nums = {-1,1,0,-3,3};
    vector<int> ans = test.productExceptSelf(nums);
    for (auto i : ans) {
        cout<< i<< ' ';
    }
}