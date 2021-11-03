#include <iostream>
#include <vector>
#include <unordered_set>

using namespace std; 

class Solution {
public:
    bool containsDuplicate(vector<int>& nums) {
        unordered_set<int> nums_traversed; 
        for (auto i : nums) {
            if (nums_traversed.find(i) != nums_traversed.end())
                return true;
            else 
                nums_traversed.insert(i);
        }
        
        return false;
    }
};

int main() {
    Solution test; 
    vector<int> nums {1,1,1,3,3,4,3,2,4,2};
    cout<<test.containsDuplicate(nums);
}