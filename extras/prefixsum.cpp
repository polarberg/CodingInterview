#include <iostream>
#include <vector>
#include <unordered_map>

using namespace std;
    
    int subarraySum(vector<int>& nums, int k) {
        int n = nums.size();
        int answer = 0; 
        int pref = 0;
        unordered_map<int,int> countPref; 
        countPref[pref]++;
        for(int R = 0; R < n; R++) {
            pref += nums[R]; 
            int need = pref - k; 
            answer += countPref[need];
            countPref[pref]++; 
        }

        return answer;
    }


int main() {
    
    vector<int> a{6, 3, -2, 4, -1, 0, -5};
    vector<int> prefsumVec;
    cout<<subarraySum(a,2);
    
    int nums[] = {6, 3, -2, 4, -1, 0, -5}; 
    cout<<sizeof(nums)<<endl;
    int n = sizeof(nums)/sizeof(nums[0]);
    for(int i=1; i<n; i++) {
        nums[i] = nums[i] + nums[i-1];
    }
    cout<<nums<<endl;

    
}