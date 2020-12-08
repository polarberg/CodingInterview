/* Given a string s which consists of lowercase or uppercase letters, return the length of the longest palindrome that can be built with those letters.
Letters are case sensitive, for example, "Aa" is not considered a palindrome here. */

#include <iostream>
#include <string>
#include <unordered_map>

using namespace std;

class Solution {
public:
    int longestPalindrome(string s) {
        unordered_map<char, int> cnt;
        unordered_map<char, int>::iterator itr;
        for(int i = 0; i< s.length(); i++) {
            cnt[s[i]]++; 
        }
        bool Odd = false; 
        int longestPalindrome = 0; 
        for(itr=cnt.begin(); itr!=cnt.end(); itr++) { // iterate through map, adding values to longestPalindrome
            longestPalindrome += (itr->second / 2) * 2; 
            if(itr->second % 2) {
                Odd = true; 
            }
        }
        
        return Odd ? longestPalindrome + 1 : longestPalindrome; 
    }
};

main() {
    Solution test;
    string s = "abccccdd";
    cout << test.longestPalindrome(s);
}