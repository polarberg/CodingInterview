#include <iostream>
#include <vector>
using namespace std;

class Solution {  
    void backtrack(vector<int>& cand, int pos, int target, vector<int> &temp, vector<vector<int>> &res) {
        if(target == 0) { // i.e.: [2,2,2,3] currSum:7 , target:7
            res.push_back(temp);
            return; 
        }
        
        for(unsigned int i = pos; i < cand.size(); i++) {
            if(cand[i] <= target) {
                temp.push_back(cand[i]);
                backtrack(cand, i, target - cand[i], temp, res);
                temp.pop_back();    // backtrack [2,2,2,2] -1  -> [2,2,2] 1 -> [2,2] 3 -> [2,2,3] 0
            }
        }
    }
    
public:
    vector<vector<int>> combinationSum(vector<int>& candidates, int target) {
        vector<int> temp;
        vector<vector<int>> res; // results        
        backtrack(candidates, 0, target, temp, res); // elem, pos, target, vector<int> temp
        
        return res;
    }

    void print(std::vector<vector<int>>  const &a) {
        std::cout << "The vector elements are : \n";

        for(auto x : a) {
            for(unsigned int i=0; i < x.size(); i++) {
                std::cout << x.at(i) << ' ';
            }
            cout<< "\n";
        }
    }
};

int main() {
    Solution test;
    vector<int> a{2,3,6,7};
    int target = 7; 
    test.print(test.combinationSum(a, target));
}

// [2,3,6,7] 7
/*
[2] target: 5
|
[2,2] 3
|
[2,2,2] 1
|
[2,2,2,2] -1
|
*/