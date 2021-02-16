// Number of Islands
/* 
    Given an m x n 2d grid map of '1's (land) and '0's (water), return the number of islands.

    An island is surrounded by water and is formed by connecting adjacent lands horizontally or vertically. 
    You may assume all four edges of the grid are all surrounded by water. */
#include <iostream>
#include <vector>
#include <utility>  // std::pair
#include <queue>

using namespace std; 

class Solution {
public:
    int numIslands(vector<vector<char>>& grid) {
        if(grid.empty() || grid[0].empty()) {
            return 0;
        }
        int H = grid.size();    // # of arrays
        int W = grid[0].size(); // all the arrays are the size
        int answer = 0; 
        auto inside = [&](int row, int col) { // Lambda Function: checks if within bounds 
            return 0 <= row && row < H && 0 <= col && col < W;
        };
        vector<pair<int,int>> directions{{1,0},{-1,0},{0,1},{0,-1}}; // (H,W) : North, South, East, West
        // vis[H][W]
        vector<vector<bool>> vis(H, vector<bool>(W));
        for(int row = 0; row < H; ++row) {
            for(int col = 0; col < W; ++col) {
                if(!vis[row][col] && grid[row][col] == '1') { // haven't visited and 
                    answer++; 
                    // BFS()
                    queue<pair<int,int>> q;
                    q.push({row,col});
                    vis[row][col] = true;
                    while(!q.empty()) {
                        pair<int,int> p = q.front(); 
                        q.pop();
                        for(pair<int,int> dir : directions) { 
                            int new_row = p.first + dir.first; 
                            int new_col = p.second + dir.second; 
                            if(inside(new_row, new_col) && !vis[new_row][new_col] && grid[new_row][new_col] == '1') { // inside grid, 
                                q.push({new_row,new_col});      
                                vis[new_row][new_col] = true;   // mark as visited so we don't add it to queue again
                            }
                        }
                    }
                }
                    
            }
        }
        return answer;
    }
};

int main() {
    //Input: 
    vector<vector<char>> grid
    {
        {'1','1','1','1','0'},
        {'1','1','0','1','0'},
        {'1','1','0','0','0'},
        {'0','0','0','0','0'}
    };
    // Expected Output: 1

    Solution test; 
    cout << test.numIslands(grid);
    return 0;
}