#include <iostream>
#include <vector>
#include <unordered_set>
#include <string>
using namespace std; 

class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        unordered_set<char> set; 
        int i = 0, j = 0, n = s.size(), maxLen = 0; 
        
        while( i < n && j < n ) { // left and right pointers in bounds  
            if(set.find(s[j]) == set.end()) {
                set.insert(s[j++]); // Insert new char in set and update j counter 
                maxLen = max(maxLen, j-i); // Check if the new distance is longer than the current answer
            }
            else {
                set.erase(s[i++]);
                /* If char exists in set (a repeated char)
                we update left side counter i, and continue checking */                
            }
        }
        
        return maxLen;
    }
};

int main() {
    Solution test; 
    string example1 ("abcabcbb");
    test.lengthOfLongestSubstring(example1);
}