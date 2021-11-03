Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

You can return the answer in any order.

https://leetcode.com/problems/two-sum/ 

class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_map<int, int> seen; // (n) solution will add every number to map (hash table)
        for(int i = 0; i < nums.size(); ++i) {
            int numberToFind = target - nums[i];
            if(seen.count(numberToFind))
                return {seen[numberToFind], i};
            seen[nums[i]] = i; 
        }
        return {};            
    }
};