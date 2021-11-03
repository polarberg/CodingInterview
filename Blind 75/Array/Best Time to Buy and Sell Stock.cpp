#include <iostream>
#include <vector>
#include <climits>

using namespace std; 

// https://leetcode.com/problems/best-time-to-buy-and-sell-stock/

class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int max = 0; 
        int min = INT_MAX; 
        int n = prices.size();
        for(int i = 0; i < n; i++) { 
            if(prices[i] < min) {   // looking for min price as max-min=greatest difference
                min = prices[i];  
            }   else {
                max = std::max(max, prices[i] - min); // always buy first and then sell later    
            }
        
        }
        return max; 
    }
};

int main() {
    Solution test; 
    vector<int> prices {7,1,5,3,6,4};
    for (int x : prices) {
        cout<< x <<' ';
    }
    cout << '\n' << test.maxProfit(prices);
    cout<<INT_MAX;
}