// Grid Minimum Path Sum
/*  Given a m x n grid filled with non-negative numbers, 
    find a path from top left to bottom right, which minimizes the sum of all numbers along its path.

    Note: You can only move either down or right at any point in time. */
#include <iostream>
#include <vector>
using namespace std; 

class Solution {
public:
    int minPathSum(vector<vector<int>>& grid) {
        const int INF = 1e9 + 9;
        int H = grid.size();
        int W = grid[0].size();
        vector<vector<int>> dp(H, vector<int>(W));
        for(int row = 0; row < H; ++row) {
            for(int col = 0; col < W; ++col) {
                if(row == 0 && col == 0) {
                    dp[row][col] = grid[row][col];
                }
                else {
                    dp[row][col] = grid[row][col] + min((row==0?INF:dp[row-1][col]) , (col==0?INF:dp[row][col-1]));    
                }
            }
        }
        return dp[H-1][W-1];
            
    }
};

int main() {
    Solution test; 
    // Input: 
    vector<vector<int>> grid 
        {
            {1,3,1},
            {1,5,1},
            {4,2,1}
        };
    cout << "Expected Output: 7" << endl; 
    // Explanation: Because the path 1 → 3 → 1 → 1 → 1 minimizes the sum.
    cout << "Output: " << test.minPathSum(grid);
}