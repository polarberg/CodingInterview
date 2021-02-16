// Longest Common Subsequence (IterativeDP and Recursive Solutions)
#include <iostream>
#include <string>
#include <vector>

using namespace std; 

class LongestCommonSubseq{
public: 
    
    // O(N*M) space and time
    int iterative_dp(string a, string b) {
        int n = a.length();
        int m = b.length();
        vector<vector<int>> dp(n + 1, vector<int>(m + 1)); // dp[0][0] = 0 , dp[i][j]
        // dp[i][j] is LCS of first i characters in string A and first j char in string b
        
        for(int i = 0; i < n; ++i) {
            for(int j = 0; j < m; ++j) {
                if(a[i] == b[j]) {
                    dp[i+1][j+1] = 1 + dp[i][j];
                }
                else { 
                    dp[i+1][j+1] = max(dp[i][j+1], dp[i+1][j]);
                }
            }
        }
        return dp[n][m];
    }
};

int main() {
    string text1 = "abcde", text2 = "ace"; 
    
    LongestCommonSubseq test; 
    cout << test.iterative_dp(text1, text2);

}